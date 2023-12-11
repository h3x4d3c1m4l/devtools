import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day11Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 11;

  @override
  String getSolution(String input) {
    List<String> lines = input.linesToList().toList(); // Simple coordinate system where (0, 0) is "bottom left"

    // Detect which column are expanding
    List<int> columnDuplications = [];
    for (int x = lines[0].length - 1; x >= 0; x--) {
      if (lines.every((line) => line[x] == '.')) {
        // Duplicate column
        columnDuplications.add(x);
      }
    }

    // New columns
    for (var columnDuplication in columnDuplications) {
      lines = lines.mapIndexed((index, element) => element.insert('.', columnDuplication)).toList();
    }

    List<int> rowDuplications = lines.expandIndexed((index, element) {
      return [if (element.split('').every((x) => x == '.')) index];
    }).toList();

    // New lines
    for (var rowDuplication in rowDuplications.reversed) {
      lines.insert(rowDuplication, ".".repeat(lines[0].length));
    }

    // Part 1
    int part1 = 0;
    for (int y1 = 0; y1 < lines.length; y1++) {
      for (int x1 = 0; x1 < lines[0].length; x1++) {
        if (lines[y1][x1] == '.') continue;

        // Hekjuhhhhh
        for (int y2 = y1; y2 < lines.length; y2++) {
          for (int x2 = (y2 == y1 ? (x1 + 1) : 0); x2 < lines[0].length; x2++) {
            if (lines[y2][x2] == '.') continue;

            // Count length
            part1 += (y2 - y1).abs() + (x2 - x1).abs();
          }
        }
      }
    }

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}
