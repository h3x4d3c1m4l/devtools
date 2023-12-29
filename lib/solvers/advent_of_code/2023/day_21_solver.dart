import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day21Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 21;

  @override
  String getSolution(String input) {
    Grid<_Tile> grid = Grid.fromString(input, _Tile.fromCharacter);

    // Part 1
    Coordinates startingPosition = grid.getCoordinatesOf(_Tile.start)!;
    Set<Coordinates> positions = {startingPosition};
    for (var step = 1; step <= 64; step++) {
      for (var position in positions.toSet()) {
        positions.remove(position);

        var north = position.goNorth();
        if (position.canGoNorth && grid.getValue(north) != _Tile.rock) positions.add(north);

        var east = position.goEast();
        if (position.canGoEast && grid.getValue(east) != _Tile.rock) positions.add(east);

        var south = position.goSouth();
        if (position.canGoSouth && grid.getValue(south) != _Tile.rock) positions.add(south);

        var west = position.goWest();
        if (position.canGoWest && grid.getValue(west) != _Tile.rock) positions.add(west);
      }
    }

    int part1 = positions.length;

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}

enum _Tile {

  start('S'),
  gardenPlot('.'),
  rock('#');

  final String character;

  const _Tile(this.character);

  factory _Tile.fromCharacter(String character) {
    return values.firstWhere((tile) => tile.character == character);
  }

  @override
  String toString() => character;

}
