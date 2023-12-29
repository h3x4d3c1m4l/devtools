import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day23Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 23;

  @override
  String getSolution(String input) {
    Grid<_Tile> grid = Grid.fromString(input, _Tile.fromCharacter);

    // Part 1
    Coordinates startingPosition = grid.getCoordinatesOf(_Tile.path)!;
    if (startingPosition.y != 0) throw Exception('Starting position not on row 0');

    List<List<Coordinates>> paths = [[startingPosition]];
    while (!paths.every((element) => element.last.y == grid.height - 1)) {
      for (List<Coordinates> path in paths.toList()) {
        _Tile lastTile = grid.getValue(path.last);
        switch (lastTile) {
          case _Tile.path:
            paths.remove(path);
            if (path.last.canGoNorth) {
              Coordinates nextStep = path.last.goNorth();
              _Tile nextStepValue = grid.getValue(nextStep);
              if (!path.contains(nextStep) && nextStepValue != _Tile.forest && nextStepValue != _Tile.southSlope) paths.add([...path, nextStep]);
            }
            if (path.last.canGoEast) {
              Coordinates nextStep = path.last.goEast();
              _Tile nextStepValue = grid.getValue(nextStep);
              if (!path.contains(nextStep) && nextStepValue != _Tile.forest && nextStepValue != _Tile.westSlope) paths.add([...path, nextStep]);
            }
            if (path.last.canGoSouth) {
              Coordinates nextStep = path.last.goSouth();
              _Tile nextStepValue = grid.getValue(nextStep);
              if (!path.contains(nextStep) && nextStepValue != _Tile.forest && nextStepValue != _Tile.northSlope) paths.add([...path, nextStep]);
            }
            if (path.last.canGoWest) {
              Coordinates nextStep = path.last.goWest();
              _Tile nextStepValue = grid.getValue(nextStep);
              if (!path.contains(nextStep) && nextStepValue != _Tile.forest && nextStepValue != _Tile.eastSlope) paths.add([...path, nextStep]);
            }
          case _Tile.northSlope:
            path.add(path.last.goNorth());
          case _Tile.eastSlope:
            path.add(path.last.goEast());
          case _Tile.southSlope:
            path.add(path.last.goSouth());
          case _Tile.westSlope:
            path.add(path.last.goWest());
          case _Tile.forest:
            throw Exception("We should not come here");
        }
      }
    }

    int part1 = paths.maxBy((element) => element.length) - 1;

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}

enum _Tile {

  path('.'),
  forest('#'),
  northSlope('^'),
  eastSlope('>'),
  southSlope('v'),
  westSlope('<');

  final String character;

  const _Tile(this.character);

  factory _Tile.fromCharacter(String character) {
    return values.firstWhere((tile) => tile.character == character);
  }

  @override
  String toString() => character;

}
