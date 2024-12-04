import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day05Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 5;

  @override
  String getSolution(String input) {
    Grid<String> grid = Grid.fromString(input, (value) => value);

    // Part 1
    int p1 = 0;

    // Part 2
    int p2 = 0;

    return 'Total of XMAS: $p1, Total of cross MAS: $p2';
  }

}
