import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/helpers/enums.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';
import 'package:h3x_devtools/solvers/helpers/grid.dart';

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
    int part1 = _gridNorthValue(_gridNorth(grid));

    // Part 2
    List<Grid<_Tile>> grids = [grid];
    int neededCycles = 1000000000;
    int neededTilts = neededCycles * 4;

    // Determine loop
    int part2 = 0;
    int loopStart = -1, loopLength = 0;
    Grid<_Tile> currentGrid = grid;
    CardinalDirection lastDirection = CardinalDirection.east;
    while (loopStart < 0) {
      currentGrid = switch (lastDirection) {
        CardinalDirection.east => _gridNorth(grids.last),
        CardinalDirection.north => _gridWest(grids.last),
        CardinalDirection.west => _gridSouth(grids.last),
        CardinalDirection.south => _gridEast(grids.last),
      };
      lastDirection = lastDirection.previousClockwise;
      
      if (loopStart < 0) {
        loopStart = grids.indexWhere((grid) => grid == currentGrid);
        loopLength = grids.length - loopStart;
      }
      grids.add(currentGrid);
    }

    var x = (((neededTilts - loopStart) / loopLength) % loopLength - loopStart).ceil();

    int count = x;
    while (count > 0) {
      currentGrid = switch (lastDirection) {
        CardinalDirection.east => _gridNorth(grids.last),
        CardinalDirection.north => _gridWest(grids.last),
        CardinalDirection.west => _gridSouth(grids.last),
        CardinalDirection.south => _gridEast(grids.last),
      };
      lastDirection = lastDirection.previousClockwise;
      grids.add(currentGrid);
      count--;
    }

    return 'Part 1: $part1\nPart 2: ${_gridNorthValue(currentGrid)}';
  }

  int _gridNorthValue(Grid<_Tile> grid) {
    int part1 = 0;
    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        if (grid.getValue(x: x, y: y) == _Tile.roundRock) {
          part1 += grid.height - y;
        }
      }
    }
    return part1;
  }

  Grid<_Tile> _gridNorth(Grid<_Tile> grid) {
    Grid<_Tile> clonedGrid = grid.clone();
    for (int y = 0; y < clonedGrid.height; y++) {
      for (int x = 0; x < clonedGrid.width; x++) {
        _Tile tile = clonedGrid.getValue(x: x, y: y);
        if (tile == _Tile.roundRock || tile == _Tile.squareRock) {
          continue;
        }

        // Check if rock can fall
        for (int y2 = y + 1; y2 < clonedGrid.height; y2++) {
          _Tile otherTile = clonedGrid.getValue(x: x, y: y2);
          if (otherTile == _Tile.squareRock) {
            break;
          } else if (otherTile == _Tile.sand) {
            continue;
          }

          clonedGrid
            ..setValue(x: x, y: y2, value: _Tile.sand)
            ..setValue(x: x, y: y, value: _Tile.roundRock);

          break;
        }
      }
    }
    return clonedGrid;
  }

  Grid<_Tile> _gridSouth(Grid<_Tile> grid) {
    Grid<_Tile> clonedGrid = grid.clone();
    for (int y = clonedGrid.height - 1; y >= 0; y--) {
      for (int x = 0; x < clonedGrid.width; x++) {
        _Tile tile = clonedGrid.getValue(x: x, y: y);
        if (tile == _Tile.roundRock || tile == _Tile.squareRock) {
          continue;
        }

        // Check if rock can fall
        for (int y2 = y - 1; y2 >= 0; y2--) {
          _Tile otherTile = clonedGrid.getValue(x: x, y: y2);
          if (otherTile == _Tile.squareRock) {
            break;
          } else if (otherTile == _Tile.sand) {
            continue;
          }

          clonedGrid
            ..setValue(x: x, y: y2, value: _Tile.sand)
            ..setValue(x: x, y: y, value: _Tile.roundRock);

          break;
        }
      }
    }
    return clonedGrid;
  }

  Grid<_Tile> _gridEast(Grid<_Tile> grid) {
    Grid<_Tile> clonedGrid = grid.clone();
    for (int x = clonedGrid.width - 1; x >= 0; x--) {
      for (int y = 0; y < clonedGrid.height; y++) {
        _Tile tile = clonedGrid.getValue(x: x, y: y);
        if (tile == _Tile.roundRock || tile == _Tile.squareRock) {
          continue;
        }

        // Check if rock can fall
        for (int x2 = x - 1; x2 >= 0; x2--) {
          _Tile otherTile = clonedGrid.getValue(x: x2, y: y);
          if (otherTile == _Tile.squareRock) {
            break;
          } else if (otherTile == _Tile.sand) {
            continue;
          }

          clonedGrid
            ..setValue(x: x2, y: y, value: _Tile.sand)
            ..setValue(x: x, y: y, value: _Tile.roundRock);

          break;
        }
      }
    }
    return clonedGrid;
  }

  Grid<_Tile> _gridWest(Grid<_Tile> grid) {
    Grid<_Tile> clonedGrid = grid.clone();
    for (int x = 0; x < clonedGrid.width; x++) {
      for (int y = clonedGrid.height - 1; y >= 0; y--) {
        _Tile tile = clonedGrid.getValue(x: x, y: y);
        if (tile == _Tile.roundRock || tile == _Tile.squareRock) {
          continue;
        }

        // Check if rock can fall
        for (int x2 = x + 1; x2 < clonedGrid.width; x2++) {
          _Tile otherTile = clonedGrid.getValue(x: x2, y: y);
          if (otherTile == _Tile.squareRock) {
            break;
          } else if (otherTile == _Tile.sand) {
            continue;
          }

          clonedGrid
            ..setValue(x: x2, y: y, value: _Tile.sand)
            ..setValue(x: x, y: y, value: _Tile.roundRock);

          break;
        }
      }
    }
    return clonedGrid;
  }

}

enum _Tile {

  roundRock('O'),
  squareRock('#'),
  sand('.');

  final String character;

  const _Tile(this.character);

  @override
  String toString() => character;

}