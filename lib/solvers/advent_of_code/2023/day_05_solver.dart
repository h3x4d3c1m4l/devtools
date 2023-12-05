import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/extensions.dart';

typedef ObjectMap = ({int destination, int length, int source});

class Day05Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 5;

  @override
  String getSolution(String input) {
    List<String> inputLineSets = input.split('\n\n');
    var inputData = (
      seeds: inputLineSets[0].substring(7).split(' ').map(int.parse),
      seedToSoilMap: _lineSetToMap(inputLineSets[1]),
      soilToFertilizerMap: _lineSetToMap(inputLineSets[2]),
      fertilizerToWaterMap: _lineSetToMap(inputLineSets[3]),
      waterToLightMap: _lineSetToMap(inputLineSets[4]),
      lightToTemperatureMap: _lineSetToMap(inputLineSets[5]),
      temperatureToHumidityMap: _lineSetToMap(inputLineSets[6]),
      humidityToLocationMap: _lineSetToMap(inputLineSets[7]),
    );

    // Part 1
    int part1 = inputData.seeds.minBy(
      (seed) => _resolveSourceToDestination(
        _resolveSourceToDestination(
          _resolveSourceToDestination(
            _resolveSourceToDestination(
              _resolveSourceToDestination(
                _resolveSourceToDestination(
                  _resolveSourceToDestination(
                    seed,
                    inputData.seedToSoilMap,
                  ),
                  inputData.soilToFertilizerMap,
                ),
                inputData.fertilizerToWaterMap,
              ),
              inputData.waterToLightMap,
            ),
            inputData.lightToTemperatureMap,
          ),
          inputData.temperatureToHumidityMap,
        ),
        inputData.humidityToLocationMap,
      ),
    );

    // Part 2
    int part2 = inputData.seeds.slices(2).expand((element) => List.generate(element[1], (e) => element[0] + e, growable: false)).minBy(
      (seed) {
        return _resolveSourceToDestination(
          _resolveSourceToDestination(
            _resolveSourceToDestination(
              _resolveSourceToDestination(
                _resolveSourceToDestination(
                  _resolveSourceToDestination(
                    _resolveSourceToDestination(
                      seed,
                      inputData.seedToSoilMap,
                    ),
                    inputData.soilToFertilizerMap,
                  ),
                  inputData.fertilizerToWaterMap,
                ),
                inputData.waterToLightMap,
              ),
              inputData.lightToTemperatureMap,
            ),
            inputData.temperatureToHumidityMap,
          ),
          inputData.humidityToLocationMap,
        );
      },
    );

    return 'Part 1: $part1\nPart 2: $part2';
  }

  List<ObjectMap> _lineSetToMap(String y) {
    return y.splitLines().skip(1).map((line) {
        var s = line.split(' ');
        return (destination: int.parse(s[0]), source: int.parse(s[1]), length: int.parse(s[2]));
      }).toList();
  }

  int _resolveSourceToDestination(int source, List<ObjectMap> map) {
    for (var mapLines in map) {
      if (source >= mapLines.source && source < (mapLines.source + mapLines.length)) {
        return source - mapLines.source + mapLines.destination;
      }
    }
    return source;
  }

}
