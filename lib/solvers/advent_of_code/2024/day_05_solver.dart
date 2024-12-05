import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day05Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 5;

  @override
  String getSolution(String input) {
    List<String> lines = input.splitLines().toList();

    List<(int, int)> orderingRules = lines.takeWhile((line) => line.isNotEmpty).map((line) {
      Iterable<int> parsedNumbers = line.split('|').map(int.parse);
      return (parsedNumbers.first, parsedNumbers.skip(1).first);
    }).toList();

    List<List<int>> updates = lines.skipWhile((line) => line.isNotEmpty).skip(1).map((line) => line.split(',').map(int.parse).toList()).toList();

    // Part 1
    int validUpdateMiddlePageNumberSum = 0;
    List<List<int>> invalidUpdates = [];
    for (List<int> update in updates) {
      bool updateIsValid = true;
      for (int i = 0; i < update.length; i++) {
        int currentPage = update[i];
        List<int> laterPages = update.skip(i + 1).toList();
        List<(int, int)> relevantOrderingRules = orderingRules.where((r) => r.$1 == currentPage || r.$2 == currentPage).toList();

        if (relevantOrderingRules.any((rule) => rule.$2 == currentPage && laterPages.any((laterPage) => laterPage == rule.$1))) {
          updateIsValid = false;
          break;
        }
      }

      if (updateIsValid) {
        validUpdateMiddlePageNumberSum += update.skip(update.length ~/ 2).first;
      } else {
        invalidUpdates.add(update); // For part 2
      }
    }

    // Part 2
    for (List<int> update in invalidUpdates) {
      bool updateIsValid = false;
      while (!updateIsValid) {
        updateIsValid = true;
        for (int i = 0; i < update.length; i++) {
          int currentPage = update[i];
          List<int> laterPages = update.skip(i + 1).toList();
          List<(int, int)> relevantOrderingRules = orderingRules.where((r) => r.$1 == currentPage || r.$2 == currentPage).toList();

          int index = laterPages.indexWhere(
            (laterPage) => relevantOrderingRules.any(
              (rule) => rule.$2 == currentPage && laterPage == rule.$1,
            ),
          );
          if (index != -1) {
            update.swap(i, index + i + 1);
            updateIsValid = false;
            break;
          }
        }
      }
    }

    int fixedUpdateMiddlePageNumberSum = invalidUpdates.map((update) => update.skip(update.length ~/ 2).first).sum;

    return 'Valid update middle page no sum: $validUpdateMiddlePageNumberSum, Fixed update middle page no sum: $fixedUpdateMiddlePageNumberSum';
  }

}
