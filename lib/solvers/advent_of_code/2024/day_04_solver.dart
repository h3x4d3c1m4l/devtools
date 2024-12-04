import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day04Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 4;

  @override
  String getSolution(String input) {
    Grid<String> grid = Grid.fromString(input, (value) => value);

    // Part 1
    int xmasCount = 0;
    for (int y = 0; y < grid.width; y++) {
      for (int x = 0; x < grid.height; x++) {
        Coordinates curXY = Coordinates(x, y, grid);
        if (grid[curXY].obj != 'X') continue;

        for (Direction direction in Direction.values) {
          const List<String> needle = ['X', 'M', 'A', 'S'];
          if (curXY.canGoDirection(direction, 3) && grid.getValues(curXY, direction, 4).equals(needle)) {
            xmasCount++;
          }
        }
      }
    }

    // Part 2
    int crossMasCount = 0;
    for (int y = 1; y < grid.width - 1; y++) {
      for (int x = 1; x < grid.height - 1; x++) {
        Coordinates curXY = Coordinates(x, y, grid);
        if (grid[curXY].obj != 'A') continue;

        const List<List<String>> needles = [['M', 'A', 'S'], ['S', 'A', 'M']];
        if (needles.any((needle) => grid.getValues(curXY.goNorthWest(), Direction.southEast, 3).equals(needle)) &&
            needles.any((needle) => grid.getValues(curXY.goSouthWest(), Direction.northEast, 3).equals(needle))) {
          crossMasCount++;
        }
      }
    }

    return 'Total of XMAS: $xmasCount, Total of cross MAS: $crossMasCount';
  }

}
