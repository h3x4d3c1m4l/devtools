import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

typedef _ClawMachineAnalysis = ({int buttonAX, int buttonAY, int buttonBX, int buttonBY, int priceX, int priceY});

class Day13Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 13;

  @override
  String getSolution(String input) {
    String splitString = input.contains('\r\n\r\n') ? '\r\n\r\n' : input.contains('\r\r') ? '\r\r' : '\n\n';
    List<_ClawMachineAnalysis> clawMachineAnalysis = input.split(splitString).map((lineSet) {
      List<List<String?>> matches = RegExp(r'X\+(\d*), Y\+(\d*)|X=(\d*), Y=(\d*)').allMatches(lineSet).map((e) => e.groups([0, 1, 2, 3, 4])).toList();
      return (buttonAX: int.parse(matches[0][1]!), buttonAY: int.parse(matches[0][2]!), buttonBX: int.parse(matches[1][1]!), buttonBY: int.parse(matches[1][2]!), priceX: int.parse(matches[2][3]!), priceY: int.parse(matches[2][4]!));
    }).toList();

    // Part 1
    int usedTokensPart1 = 0;
    for (({int buttonAX, int buttonAY, int buttonBX, int buttonBY, int priceX, int priceY}) analysis in clawMachineAnalysis) {
      usedTokensPart1 += _getUsedTokens(analysis, false) ?? 0;
    }

    // Part 2
    int usedTokensPart2 = 0;
    for (({int buttonAX, int buttonAY, int buttonBX, int buttonBY, int priceX, int priceY}) analysis in clawMachineAnalysis) {
      usedTokensPart2 += _getUsedTokens(analysis, true) ?? 0;
    }

    return 'Fewest tokens: $usedTokensPart1, fewest tokens correct: $usedTokensPart2';
  }

}

int? _getUsedTokens(_ClawMachineAnalysis analysis, bool part2) {
  double a1 = analysis.buttonAX.toDouble(), b1 = analysis.buttonBX.toDouble(), equals1 = analysis.priceX.toDouble() + (part2 ? 10000000000000 : 0);
  double a2 = analysis.buttonAY.toDouble(), b2 = analysis.buttonBY.toDouble(), equals2 = analysis.priceY.toDouble() + (part2 ? 10000000000000 : 0);

  // Use method of elimination
  double elimFactor = -a1 / a2;
  double b2Elim = b2 * elimFactor;
  double equalsElim = equals2 * elimFactor;

  double bAfterElim = b1 + b2Elim;
  double equalsAfterElim = equals1 + equalsElim;

  double bButtonPresses = equalsAfterElim / bAfterElim;
  double aButtonPresses = (equals1 - b1 * bButtonPresses) / a1;

  const double epsilon = 0.001;
  if ((aButtonPresses - aButtonPresses.round()).abs() <= epsilon &&
      (bButtonPresses - bButtonPresses.round()).abs() <= epsilon) {
    // Valid result
    return aButtonPresses.round() * 3 + bButtonPresses.round();
  }

  return null;
}
