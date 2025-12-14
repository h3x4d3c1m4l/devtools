import 'package:characters/characters.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2025/aoc_2025_solver.dart';

class Day03Solver extends AdventOfCode2025Solver {

  @override
  final int dayNumber = 3;

  @override
  String getSolution(String input) {
    List<List<int>> batteryBanks = input.splitLines().map((line) => line.characters.map(int.parse).toList()).toList();

    // Part 1
    int totalJoltage2 = 0;
    for (List<int> bank in batteryBanks) {
      int highest = 0;
      for (var i = 0; i < bank.length; i++) {
        for (var j = i + 1; j < bank.length; j++) {
          int joltage = bank[i] * 10 + bank[j];
          if (joltage > highest) highest = joltage;
        }
      }
      totalJoltage2 += highest;
    }

    // Part 2
    const int nBatteries = 12;
    int totalJoltage12 = 0;
    for (List<int> bank in batteryBanks) {
      int lastIndex = -1;

      int largestJoltage = 0;
      for (int i = 0; i < nBatteries; i++) {
        List<int> subBank = bank.skip(lastIndex + 1).take(bank.length - (nBatteries - i - 1) - (lastIndex + 1)).toList();
        int maxOfRow = subBank.max;
        int firstIndexOfMax = subBank.indexOf(maxOfRow) + lastIndex + 1;
        lastIndex = firstIndexOfMax;

        largestJoltage += (maxOfRow * pow(10, nBatteries - i - 1)) as int;
      }

      totalJoltage12 += largestJoltage;
    }

    return 'Total output joltage (2): $totalJoltage2, Total output joltage (12): $totalJoltage12';
  }

}
