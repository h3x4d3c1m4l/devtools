import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/extensions.dart';

class Day01Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 1;

  static const Map<String, int> _digitNames = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
  };

  @override
  String getSolution(String input) {
    List<String> rawCalibrationLines = input.splitLines().toList();

    // Part 1
    int totalCalibrationValuePart1 = 0;
    for (String line in rawCalibrationLines) {
      List<int> lineCodeUnits = line.codeUnits;

      int? firstCodeUnit = lineCodeUnits.firstWhereOrNull((element) => element >= 48 && element <= 57);
      int? lastCodeUnit = lineCodeUnits.lastWhereOrNull((element) => element >= 48 && element <= 57);
      if (firstCodeUnit != null && lastCodeUnit != null) {
        totalCalibrationValuePart1 += (firstCodeUnit - 48) * 10 + (lastCodeUnit - 48);
      }
    }

    // Part 2
    int totalCalibrationValuePart2 = 0;
    for (String line in rawCalibrationLines) {
      int? firstDigit, lastDigit;

      for (int i = 0; i < line.length; i++) {
        // First check if there's a digit here
        int codeUnit = line.codeUnits[i];
        if (codeUnit >= 48 && codeUnit <= 57) {
          firstDigit ??= codeUnit - 48;
          lastDigit = codeUnit - 48;
          continue;
        }

        // If not check if there's a text digit here
        for (String digitName in _digitNames.keys) {
          if (line.substring(i).startsWith(digitName)) {
            firstDigit ??= _digitNames[line.substring(i, i + digitName.length)];
            lastDigit = _digitNames[line.substring(i, i + digitName.length)];
          }
        }
      }

      totalCalibrationValuePart2 += firstDigit! * 10 + lastDigit!;
    }

    return 'Total calibration value: $totalCalibrationValuePart1\nTotal correct calibration value: $totalCalibrationValuePart2';
  }

}
