import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day01Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 1;

  @override
  String getSolution(String input) {
    List<List<int>> locationIdGroups = input.splitLines().map((line) => line.split('   ').parsedAsInts.toList()).toList();

    // Part 1
    List<int> list1Sorted = locationIdGroups.map((group) => group[0]).toList()..sort();
    List<int> list2Sorted = locationIdGroups.map((group) => group[1]).toList()..sort();

    int totalDistance = list1Sorted.foldIndexed(0, (i, prev, elem) => prev + (elem - list2Sorted[i]).abs());

    // Part 2
    int totalSimilarity = list1Sorted.foldIndexed(0, (_, prev, elem) => prev + elem * list2Sorted.countValueOccurances(elem));

    return 'Total distance: $totalDistance, total similarity: $totalSimilarity';
  }

}
