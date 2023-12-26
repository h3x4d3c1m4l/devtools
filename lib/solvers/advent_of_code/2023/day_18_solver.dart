import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

typedef DigPlanLine = ({String color, CardinalDirection direction, int meters});

class Day18Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 18;

  @override
  String getSolution(String input) {
    List<DigPlanLine> rawDigPlanLines = input.splitLines().map((rawDigPlanLine) {
      var split = rawDigPlanLine.split(' ');
      return (
        direction: switch (split[0]) {
          'L' => CardinalDirection.west,
          'R' => CardinalDirection.east,
          'U' => CardinalDirection.north,
          'D' => CardinalDirection.south,
          _ => throw Exception('Cannot parse ${split[0]} as $CardinalDirection}'),
        },
        meters: int.parse(split[1]),
        color: split[2].substring(2, 8),
      );
    }).toList();
    Grid<_Tile> grid = Grid.filled(width: 1000, height: 1000, initialValue: _Tile.sand);

    // Part 1
    Coordinates lastCoordinates = Coordinates(500, 500, grid);
    for (DigPlanLine digPlanLine in rawDigPlanLines) {
      for (int i = 0; i < digPlanLine.meters; i++) {
        switch (digPlanLine.direction) {
          case CardinalDirection.north:
            lastCoordinates = lastCoordinates.goNorth();
          case CardinalDirection.east:
            lastCoordinates = lastCoordinates.goEast();
          case CardinalDirection.south:
            lastCoordinates = lastCoordinates.goSouth();
          case CardinalDirection.west:
            lastCoordinates = lastCoordinates.goWest();
          default:
            throw Exception('Direction ${digPlanLine.direction} unsupported');
        }
        grid.setValue(lastCoordinates, _Tile.diggedSand);
      }
    }

    // Ugly code to find inside point to start fill
    Coordinates? scoordinates;
    for (var y = 0; y < grid.height; y++) {
      for (var x = 0; x < grid.width; x++) {
        Coordinates coordinates = Coordinates(x, y, grid);
        if (grid.getValue(coordinates) == _Tile.diggedSand) {
          Coordinates coordinates2 = Coordinates(x + 1, y + 1, grid);
          if (grid.getValue(coordinates2) == _Tile.sand) {
            scoordinates = coordinates2;
            break;
          }
        }
      }

      if (scoordinates != null) break;
    }

    grid.floodFill4Way(scoordinates!, _Tile.sand, _Tile.diggedSand);
    int part1 = grid.rows.flattened.where((cell) => cell.obj == _Tile.diggedSand).length;

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}

enum _Tile {

  sand('.'),
  diggedSand('#');

  final String character;

  const _Tile(this.character);

  @override
  String toString() => character;

}
