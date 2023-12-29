import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day10Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 10;

  @override
  String getSolution(String input) {
    Grid<_Tile> grid = Grid<_Tile>.fromString(input, _Tile.fromCharacter)..flipVertically();
  
    // Part 1
    Map<Coordinates, bool> mainLoopTiles = {};

    Coordinates current = grid.getCoordinatesOf(_Tile.startingPosition)!;
    CardinalDirection? currentDirection;
    int steps = 0;

    while (true) {
      final _Tile tile = grid.getValue(current);
      if (tile == _Tile.startingPosition && steps > 0) break;

      mainLoopTiles[current] = true;
      
      // Evaluation of possible steps based on grid bounds
      List<(Coordinates coordinates, CardinalDirection direction, _Tile tile)> possibleNextSteps = [
        if (current.canGoWest && tile.allowedDirections.contains(CardinalDirection.west))
          (current.goWest(), CardinalDirection.west, grid.getValue(current.goWest())),
        if (current.canGoNorth && tile.allowedDirections.contains(CardinalDirection.south))
          (current.goNorth(), CardinalDirection.south, grid.getValue(current.goNorth())),
        if (current.canGoEast && tile.allowedDirections.contains(CardinalDirection.east))
          (current.goEast(), CardinalDirection.east, grid.getValue(current.goEast())),
        if (current.canGoSouth && tile.allowedDirections.contains(CardinalDirection.north))
          (current.goSouth(), CardinalDirection.north, grid.getValue(current.goSouth())),
      ];

      final (Coordinates coordinates, CardinalDirection direction, _Tile _) = possibleNextSteps.firstWhere((obj) {
        return 
          // Either we are on the 'start' tile and everything is possible except 'ground'
          (currentDirection == null && obj.$3 != _Tile.ground) ||

          // Or we are on any other tile and we need to make sure we don't accidentally reverse direction
          (currentDirection != null && obj.$2 != currentDirection.opposing);
      });

      current = coordinates; currentDirection = direction;
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

  factory _Tile.fromCharacter(String character) {
    return values.firstWhere((tile) => tile.character == character);
  }

  @override
  String toString() => character;

}
