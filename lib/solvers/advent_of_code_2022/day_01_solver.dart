import 'package:aoc22/solvers/solver.dart';

class Day01Solver extends Solver<String, String> {
  
  @override
  String getSolution(String input) {
    Iterable<String> splitInput = input.split('\n\n').where((elfCaloriesStr) => elfCaloriesStr.isNotEmpty);

    int highestCalorieCount = 0;
    List<int> allElfCalories = [];
    for (String elfCaloriesStr in splitInput) {
      int elfCalories = elfCaloriesStr
          .split('\n')
          .map((elfCalorieStr) => int.parse(elfCalorieStr))
          .reduce((value, element) => value + element);
      allElfCalories.add(elfCalories);

      if (elfCalories > highestCalorieCount) {
        highestCalorieCount = elfCalories;
      }
    }
    allElfCalories.sort((a, b) => a < b ? 1 : -1);

    int topThreeTotal = allElfCalories.take(3).reduce((value, element) => value + element);
    return 'Highest: $highestCalorieCount\nTop 3\'s total: $topThreeTotal';
  }

}
