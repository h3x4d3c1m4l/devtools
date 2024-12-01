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

    int totalDistance = list1Sorted.foldIndexed(0, (index, previous, element) => previous + (element - list2Sorted[index]).abs());

    // Part 2
    List<int> list1 = locationIdGroups.map((group) => group[0]).toList();
    List<int> list2 = locationIdGroups.map((group) => group[1]).toList();

    int totalSimilarity = list1.foldIndexed(0, (index, previous, element) => previous + element * list2.countValueOccurances(element));

    return 'Total distance: $totalDistance, total similarity: $totalSimilarity';
  }

}
