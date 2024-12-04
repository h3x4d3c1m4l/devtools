import 'package:h3x_devtools/solvers/advent_of_code/2021/aoc_2021_solver.dart';

class Day03Solver extends AdventOfCode2021Solver {

  @override
  final int dayNumber = 3;

  @override
  String getSolution(String input) {
    // Part 1
    Grid<String> grid = Grid.fromString(input, (value) => value);
    StringBuffer bits = StringBuffer();
    for (List<Cell<String>> column in grid.columns) {
      bits.writeCharCode(column.map((column) => int.parse(column.obj)).average.round() + 48);
    }
    int gammaRate = int.parse(bits.toString(), radix: 2);
    int epsilonRate = ~gammaRate & ((1 << grid.width) - 1);
    int powerConsumption = gammaRate * epsilonRate;

    // Part 2
    input.splitLines().

    return 'Power consumption: $powerConsumption\nHorizontal position times final depth (part 2): $num2';
  }

}
