import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day11Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 11;

  @override
  String getSolution(String input) {
    List<String> lines = input.toListOfLines().toList(); // Simple coordinate system where (0, 0) is "bottom left"

    // Detect which column and rows are expanding
    List<int> columnDuplications = [];
    for (int x = lines[0].length - 1; x >= 0; x--) {
      if (lines.every((line) => line[x] == '.')) {
        // Duplicate column
        columnDuplications.add(x);
      }
    }

    List<int> rowDuplications = lines.expandIndexed((index, element) {
      return [if (element.split('').every((x) => x == '.')) index];
    }).toList();

    // Part 1
    int part1 = _getSumOfLengths(lines, rowDuplications, columnDuplications, 2);

    // Part 2
    int part2 = _getSumOfLengths(lines, rowDuplications, columnDuplications, 1000000);

    return 'Part 1: $part1\nPart 2: $part2';
  }

  int _getSumOfLengths(List<String> lines, List<int> rowDuplications, List<int> columnDuplications, int mul) {
    int sumOfLength = 0;
    for (int y1 = 0; y1 < lines.length; y1++) {
      for (int x1 = 0; x1 < lines[0].length; x1++) {
        if (lines[y1][x1] == '.') continue;

        // Hekjuhhhhh
        for (int y2 = y1; y2 < lines.length; y2++) {
          for (int x2 = (y2 == y1 ? (x1 + 1) : 0); x2 < lines[0].length; x2++) {
            if (lines[y2][x2] == '.') continue;

            // Check if we cross empty rows
            int emptyRowCount =
                rowDuplications.where((index) => (index > y1 && index < y2) || (index < y1 && index > y2)).length;

            int emptyColumnCount =
                columnDuplications.where((index) => (index > x1 && index < x2) || (index < x1 && index > x2)).length;

            // Calculate sum of normal lengths without expansion, then add the expansion
            sumOfLength += (y2 - y1).abs() + (x2 - x1).abs();
            sumOfLength += emptyRowCount * (mul - 1) + emptyColumnCount * (mul - 1);
          }
        }
      }
    }
    return sumOfLength;
  }

}
