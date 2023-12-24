import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day10Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 10;

  @override
  String getSolution(String input) {
    List<String> lines = input.toListOfLines().reversed.toList(); // Simple coordinate system where (0, 0) is "bottom left"
    Grid<_Tile> grid = Grid<_Tile>.generated(width: lines.first.length, height: lines.length, getValue: (x, y) {
      String character = lines[y][x];
      return _Tile.fromCharacter(character);
    });
  
    // Part 1
    Map<(int x, int y), bool> mainLoopTiles = {};
    final (:int x, :int y) = grid.getCoordinatesOf(_Tile.startingPosition)!;

    int currentX = x, currentY = y;
    CardinalDirection? currentDirection;
    int steps = 0;

    while (true) {
      final _Tile tile = grid.getValue(x: currentX, y: currentY);
      if (tile == _Tile.startingPosition && steps > 0) break;

      mainLoopTiles[(currentX, currentY)] = true;
      
      // Evaluation of possible steps based on grid bounds
      List<(int x, int y, CardinalDirection direction, _Tile tile)> possibleNextSteps = [
        if (currentX > 0 && tile.allowedDirections.contains(CardinalDirection.west))
          (currentX - 1, currentY, CardinalDirection.west, grid.getValue(x: currentX - 1, y: currentY)),
        if (currentY > 0 && tile.allowedDirections.contains(CardinalDirection.south))
          (currentX, currentY - 1, CardinalDirection.south, grid.getValue(x: currentX, y: currentY - 1)),
        if (currentX < (grid.width - 1) && tile.allowedDirections.contains(CardinalDirection.east))
          (currentX + 1, currentY, CardinalDirection.east, grid.getValue(x: currentX + 1, y: currentY)),
        if (currentY < (grid.height - 1) && tile.allowedDirections.contains(CardinalDirection.north))
          (currentX, currentY + 1, CardinalDirection.north, grid.getValue(x: currentX, y: currentY + 1)),
      ];

      final (int x, int y, CardinalDirection direction, _Tile _) = possibleNextSteps.firstWhere((obj) {
        return 
          // Either we are on the 'start' tile and everything is possible except 'ground'
          (currentDirection == null && obj.$4 != _Tile.ground) ||

          // Or we are on any other tile and we need to make sure we don't accidentally reverse direction
          (currentDirection != null && obj.$3 != currentDirection.opposing);
      });

      currentX = x; currentY = y; currentDirection = direction;
      steps++;
    }

    var part1 = steps ~/ 2;

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}

enum _Tile {

  verticalPipe('|', [CardinalDirection.north, CardinalDirection.south]),
  horizontalPipe('-', [CardinalDirection.east, CardinalDirection.west]),
  northEastBend('L', [CardinalDirection.north, CardinalDirection.east]),
  northWestBend('J', [CardinalDirection.north, CardinalDirection.west]),
  southWestBend('7', [CardinalDirection.south, CardinalDirection.west]),
  southEastBend('F', [CardinalDirection.south, CardinalDirection.east]),
  ground('.', []),
  startingPosition('S', [CardinalDirection.north, CardinalDirection.east, CardinalDirection.south, CardinalDirection.west]);

  final String character;
  final List<CardinalDirection> allowedDirections;

  const _Tile(this.character, this.allowedDirections);

  static _Tile fromCharacter(String character) {
    return switch (character) {
      '|' => _Tile.verticalPipe,
      '-' => _Tile.horizontalPipe,
      'L' => _Tile.northEastBend,
      'J' => _Tile.northWestBend,
      '7' => _Tile.southWestBend,
      'F' => _Tile.southEastBend,
      '.' => _Tile.ground,
      'S' => _Tile.startingPosition,
      _ => throw Exception("Cannot parse '$character' into Tile"),
    };
  }

  @override
  String toString() => character;

}
