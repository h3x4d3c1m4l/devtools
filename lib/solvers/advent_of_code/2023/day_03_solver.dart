import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day03Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 3;

  @override
  String getSolution(String input) {
    // Parse input
    var engineSchematicLines = input.splitLines().toList();

    // Part 1 and 2 combined
    int sumOfPartNumbers = 0;
    Map<(int, int), List<int>> gearPartNumbers = {};

    for (var y = 0; y < engineSchematicLines.length; y++) {
      // Lines
      String line = engineSchematicLines[y];
      int currentNumber = 0;
      bool isPartNumber = false;
      (int, int)? adjGearCoordinates;

      for (var x = 0; x < line.length; x++) {
        // Chars
        int character = line.codeUnitAt(x);

        // Check is digit
        if (character.isDigit) {
          currentNumber = currentNumber * 10 + (character - 48);

          // Check digit adjacency to symbol (first we determine bounds)
          int xAdjMin = max(0, x - 1), xAdjMax = min(line.length - 1, x + 1);
          int yAdjMin = max(0, y - 1), yAdjMax = min(engineSchematicLines.length - 1, y + 1);
          for (int xAdj = xAdjMin; xAdj <= xAdjMax; xAdj++) {
            for (int yAdj = yAdjMin; yAdj <= yAdjMax; yAdj++) {
              int adjChar = engineSchematicLines[yAdj].codeUnitAt(xAdj);
              if (!adjChar.isDigit && !adjChar.isDot) {
                isPartNumber = true;

                // Part 2: Check if gear
                if (adjChar == 42) adjGearCoordinates = (xAdj, yAdj);

                break;
              }
            }

            if (isPartNumber) break;
          }
        } else if (character.isDot) {
          // Reset state due to dot encountered
          if (isPartNumber) sumOfPartNumbers += currentNumber;
          if (adjGearCoordinates != null) (gearPartNumbers[(adjGearCoordinates.$1, adjGearCoordinates.$2)] ??= []).add(currentNumber);
          isPartNumber = false;
          adjGearCoordinates = null;
          currentNumber = 0;
        } else {
          // Reset state due to other type of characters encountered
          if (isPartNumber) sumOfPartNumbers += currentNumber;
          if (adjGearCoordinates != null) (gearPartNumbers[(adjGearCoordinates.$1, adjGearCoordinates.$2)] ??= []).add(currentNumber);
          isPartNumber = false;
          adjGearCoordinates = null;
          currentNumber = 0;
        }
      }

      // Reset state due to new line
      if (isPartNumber) sumOfPartNumbers += currentNumber;
      if (adjGearCoordinates != null) (gearPartNumbers[(adjGearCoordinates.$1, adjGearCoordinates.$2)] ??= []).add(currentNumber);
      isPartNumber = false;
      adjGearCoordinates = null;
      currentNumber = 0;
    }

    // Part 2
    int sumOfGearRatios = gearPartNumbers.entries
        .where((kv) => kv.value.length == 2)
        .fold(0, (previousValue, element) => previousValue + element.value[0] * element.value[1]);

    return 'Sum of part numbers: $sumOfPartNumbers\nSum of power: $sumOfGearRatios';
  }

}
