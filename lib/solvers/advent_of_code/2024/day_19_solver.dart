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
      if (!_isDesignPossible([], pattern, nonCompositablePatterns).isNotEmpty) nonCompositablePatterns.add(pattern);
    }

    // Now we check which designs are possible.
    int possibleDesigns = desiredDesigns.where((design) => _isDesignPossible([], design, nonCompositablePatterns).isNotEmpty).length;

    // Part 2 - Check all possibilities of pattern compositions
    Map<String, int> compositionCount = {};
    for (String pattern in towelPatterns) {
      compositionCount[pattern] = _isDesignPossible([], pattern, towelPatterns).length;
    }

    int y = 0;
    for (String design in desiredDesigns) {
      Iterable<List<String>> possibleDesigns = _isDesignPossible([], design, nonCompositablePatterns);
      print(possibleDesigns.length);

      int z = 0;
      for (List<String> patterns in possibleDesigns) {
        int x = 1;
        for (String pattern in patterns) {
          x *= compositionCount[pattern]!;
        }
        z += x;
      }
      y += z;
    }

    return 'Possible designs: $possibleDesigns, part 2: $y';
  }

  Iterable<List<String>> _isDesignPossible(List<String> currentPattern, String desiredPattern, List<String> towelPatterns) sync* {
    for (String pattern in towelPatterns) {
      String testingPattern = '${currentPattern.join()}$pattern';
      if (testingPattern == desiredPattern) {
        yield [...currentPattern, pattern];
      } else if (testingPattern.length < desiredPattern.length && desiredPattern.startsWith(testingPattern)) {
        yield* _isDesignPossible([...currentPattern, pattern], desiredPattern, towelPatterns);
      }
    }
  }

}
