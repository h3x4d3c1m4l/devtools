import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day03Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 3;

  @override
  String getSolution(String input) {
    // Part 1
    RegExp mulFinderRegExp = RegExp(r'mul\((\d*),(\d*)\)');
    int totalOfMuls = mulFinderRegExp.allMatches(input).map((match) {
      return int.parse(match.group(1)!) * int.parse(match.group(2)!);
    }).sum;

    // Part 2
    RegExp instructionFinderRegExp = RegExp(r"(?:mul\((\d*),(\d*)\))|(do\(\))|(don't\(\))");
    bool addIsEnabled = true;
    int totalOfInstructions = instructionFinderRegExp.allMatches(input).map((match) {
      switch (match.group(0)!) {
        case 'do()': addIsEnabled = true; return 0;
        case "don't()": addIsEnabled = false; return 0;
        default: return addIsEnabled ? int.parse(match.group(1)!) * int.parse(match.group(2)!) : 0;
      }
    }).sum;

    return 'Total of muls: $totalOfMuls, Total of instructions: $totalOfInstructions';
  }

}
