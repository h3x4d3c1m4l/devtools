import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day15Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 15;

  @override
  String getSolution(String input) {
    List<String> rawInstructions = input.replaceAll('\n', '').split(',').toList();

    // Part 1
    int part1 = rawInstructions.fold(0, (previousValue, element) {
      return previousValue + _holidayAsciiStringHelperAlgorithm(element);
    });

    // Part 2
    List<List<(String, int)>> lensBoxes = List.generate(256, (index) => <(String, int)>[]);
    for (var rawInstruction in rawInstructions) {
      String lensLabel = rawInstruction.toCharacters().takeWhile((char) => char != '=' && char != '-').join();

      // Find box by hash
      int boxIndex = _holidayAsciiStringHelperAlgorithm(lensLabel);
      List<(String, int)> box = lensBoxes[boxIndex];

      var instruction = rawInstruction.split('=');
      if (instruction.length == 1) {
        // e.g. cm-
        box.removeWhere((x) => x.$1 == lensLabel); // tricky
      } else if (instruction.length == 2) {
        // e.g. ot=9
        int focalLength = int.parse(instruction[1]);
        int existingLabelIndex = box.indexWhere((lens) => lens.$1 == lensLabel);
        if (existingLabelIndex == -1) {
          // New lens
          box.add((lensLabel, focalLength));
        } else {
          // Replace existing lens
          box[existingLabelIndex] = (lensLabel, focalLength);
        }
      } else {
        throw Exception('Cannot parse instruction $rawInstruction');
      }
    }

    int totalFocusingPower = lensBoxes.foldIndexed(0, (boxIndex, cumFocusingPower, lensBox) {
      return cumFocusingPower + lensBox.foldIndexed(0, (lensIndex, cumBoxFocusingPower, lens) {
        return cumBoxFocusingPower + (boxIndex + 1) * (lensIndex + 1) * lens.$2;
      });
    });

    return 'Part 1: $part1\nPart 2: $totalFocusingPower';
  }

  int _holidayAsciiStringHelperAlgorithm(String str) {
    return str.codeUnits.fold(0, (previousValue, element) => ((previousValue + element) * 17) % 256);
  }

}
