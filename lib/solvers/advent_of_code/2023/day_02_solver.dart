import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day02Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 2;

  @override
  String getSolution(String input) {
    // Parse input
    var games = input
      .split('\n') // Split on games
      .where((rawGameLine) => rawGameLine.isNotEmpty)
      .map((rawGameLine) {
        List<String> gameLineSplit = rawGameLine.split(':'); // Split game no and cube sets
        return (
          gameId: int.parse(gameLineSplit[0].substring(5)),
          cubeCountSets: gameLineSplit[1].split(';').map((rawCubeSet) { // Split cube sets
            List<String> rawCubes = rawCubeSet.split(','); // Split cube counts
            return rawCubes.map((rawCube) {
              var rawCubeSplit = rawCube.substring(1).split(' '); // Split count and color
              return (
                cubeCount: int.parse(rawCubeSplit[0].trimLeft()),
                color: rawCubeSplit[1].trimRight(),
              );
            }).toList();
          }).toList(),
        ); 
      })
      .toList();

    // Part 1
    const maxRedCube = 12, maxGreenCubes = 13, maxBlueCubes = 14;
    int sumOfGameIds = games
        .where(
          (game) => game.cubeCountSets.every(
            (cubeCountSet) => cubeCountSet.every(
              // Check if the game could be played
              (cubeCount) => switch (cubeCount.color) {
                'red' => cubeCount.cubeCount <= maxRedCube,
                'green' => cubeCount.cubeCount <= maxGreenCubes,
                'blue' => cubeCount.cubeCount <= maxBlueCubes,
                _ => throw Exception('Unrecognised color: ${cubeCount.color}'),
              },
            ),
          ),
        )
        .map((x) => x.gameId).sum;

    // Part 2
    var sumOfPower = games.map(
      // Find the minimum cube count per game per color
      (game) {
        var cubeCounts = game.cubeCountSets.flattened.toList();
        return (
          minimumRedCubes: cubeCounts.where((cubeCount) => cubeCount.color == 'red').map((cubeCount) => cubeCount.cubeCount).max,
          minimumGreenCubes: cubeCounts.where((cubeCount) => cubeCount.color == 'green').map((cubeCount) => cubeCount.cubeCount).max,
          minimumBlueCubes: cubeCounts.where((cubeCount) => cubeCount.color == 'blue').map((cubeCount) => cubeCount.cubeCount).max,
        );
      },
    ).fold(
      0,
      (previousValue, game) => previousValue += game.minimumRedCubes * game.minimumGreenCubes * game.minimumBlueCubes,
    );

    return 'Sum of game IDs: $sumOfGameIds\nSum of power: $sumOfPower';
  }

}
