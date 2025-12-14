import 'package:h3x_devtools/solvers/advent_of_code/2025/aoc_2025_solver.dart';

class Day04Solver extends AdventOfCode2025Solver {

  @override
  final int dayNumber = 4;

  @override
  String getSolution(String input) {
    Grid<bool> grid = Grid.fromString(input, (char) => char == '@');

    // Part 1
    int accessibleScrollsOfPaper = 0;
    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        Coordinates coordinates = Coordinates(x, y, grid);
        if (!grid.getValue(coordinates)) continue;

        int adjScrolls = 0;
        if (coordinates.canGoNorth && grid.getValue(coordinates.goNorth())) adjScrolls++;
        if (coordinates.canGoNorthEast && grid.getValue(coordinates.goNorthEast())) adjScrolls++;
        if (coordinates.canGoEast && grid.getValue(coordinates.goEast())) adjScrolls++;
        if (coordinates.canGoSouthEast && grid.getValue(coordinates.goSouthEast())) adjScrolls++;
        if (coordinates.canGoSouth && grid.getValue(coordinates.goSouth())) adjScrolls++;
        if (coordinates.canGoSouthWest && grid.getValue(coordinates.goSouthWest())) adjScrolls++;
        if (coordinates.canGoWest && grid.getValue(coordinates.goWest())) adjScrolls++;
        if (coordinates.canGoNorthWest && grid.getValue(coordinates.goNorthWest())) adjScrolls++;

        if (adjScrolls < 4) accessibleScrollsOfPaper++;
      }
    }

    // Part 2
    // TODO

    return 'Accessible rolls of paper: $accessibleScrollsOfPaper';
  }

}
