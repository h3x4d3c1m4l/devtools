import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';

class Day01Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 1;
  
  @override
  String getSolution(String input) {
    // TODO: fix possible newline issue due to usage of \n\n.
    Iterable<String> splitInput = input.split('\n\n').where((elfCaloriesStr) => elfCaloriesStr.isNotEmpty);

    // part 1
    int highestCalorieCount = 0;
    List<int> allElfCalories = [];
    for (String elfCaloriesStr in splitInput) {
      int elfCalories = elfCaloriesStr
          .split('\n')
          .map(int.parse)
          .reduce((value, element) => value + element);
      allElfCalories.add(elfCalories);

      if (elfCalories > highestCalorieCount) {
        highestCalorieCount = elfCalories;
      }
    }

    // part 2
    allElfCalories.sort((a, b) => a < b ? 1 : -1);
    int topThreeTotal = allElfCalories.take(3).reduce((value, element) => value + element);

    return 'Highest: $highestCalorieCount\nTop 3\'s total: $topThreeTotal';
  }

}
