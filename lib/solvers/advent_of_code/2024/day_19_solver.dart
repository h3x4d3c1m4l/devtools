import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day19Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 19;

  @override
  String getSolution(String input) {
    String splitNewline = input.contains('\r\n\r\n') ? '\r\n\r\n' : input.contains('\r\r') ? '\r\r' : '\n\n';
    List<String> inputParts = input.split(splitNewline);

    List<String> towelPatterns = inputParts[0].split(', ').toList();
    List<String> desiredDesigns = inputParts[1].toListOfLines();

    // Part 1 - First we filter all patterns that can't be composited themselves.
    List<String> nonCompositablePatterns = [...towelPatterns];
    for (String pattern in towelPatterns) {
      nonCompositablePatterns.remove(pattern);
      if (!_getPossibleDesigns([], pattern, nonCompositablePatterns).isNotEmpty) nonCompositablePatterns.add(pattern);
    }

    // Now we check which designs are possible.
    int possibleDesigns = desiredDesigns.where((design) => _getPossibleDesigns([], design, nonCompositablePatterns).isNotEmpty).length;

    return 'Possible designs: $possibleDesigns';
  }

  Iterable<List<String>> _getPossibleDesigns(List<String> currentPattern, String desiredPattern, List<String> towelPatterns) sync* {
    for (String pattern in towelPatterns) {
      String testingPattern = '${currentPattern.join()}$pattern';
      if (testingPattern == desiredPattern) {
        yield [...currentPattern, pattern];
      } else if (testingPattern.length < desiredPattern.length && desiredPattern.startsWith(testingPattern)) {
        yield* _getPossibleDesigns([...currentPattern, pattern], desiredPattern, towelPatterns);
      }
    }
  }

}
