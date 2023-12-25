import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day14Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 14;

  @override
  String getSolution(String input) {
    // Parse input
    var lines = input.splitLines().toList();
    Grid<_Tile> grid = Grid.generated(width: lines[0].length, height: lines.length, getValue: (x, y) {
      return switch (lines[y][x]) {
        '#' => _Tile.squareRock,
        'O' => _Tile.roundRock,
        '.' => _Tile.sand,
        _ => throw Exception("Could not parse input character")
      };
    });

    // Part 1
    int part1 = 0;
    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        Coordinates coordinates = Coordinates(x, y);
        _Tile tile = grid.getValue(coordinates);
        if (tile == _Tile.roundRock) {
          part1 += grid.height - y;
          continue;
        } else if (tile == _Tile.squareRock) {
          continue;
        }

        // Check if rock can fall
        for (int y2 = y + 1; y2 < grid.height; y2++) {
          Coordinates otherCoordinates = Coordinates(x, y2);
          _Tile otherTile = grid.getValue(otherCoordinates);
          if (otherTile == _Tile.squareRock) {
            break;
          } else if (otherTile == _Tile.sand) {
            continue;
          }

          grid
            ..setValue(otherCoordinates, _Tile.sand)
            ..setValue(coordinates, _Tile.roundRock);

          part1 += grid.height - y;
          break;
        }
      }
    }

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}

enum _Tile {
  roundRock,
  squareRock,
  sand,
}
