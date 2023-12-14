import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day13Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 13;

  @override
  String getSolution(String input) {
    List<String> rawPatterns = input.split('\n\n').toList();
  
    // Part 1
    int part1 = 0;
    List<List<String>> patterns = rawPatterns.map((rawPattern) => rawPattern.splitLines().toList()).toList();
    for (List<String> patternLines in patterns) {
      List<String> patternColumns = patternLines.first.codeUnits
        .mapIndexed((index, element) => patternLines.map((e) => e[index]).join(''))
        .toList();

      part1 += _getPatternStartIndices(patternLines).sum * 100;
      part1 += _getPatternStartIndices(patternColumns).sum;
    }

    // Part 2
    int part2 = 0;
    for (List<String> patternLines in patterns) {
      // NOTE: Only summarize NEW reflection lines

      // Rows
      List<int> oldRowPatternStartIndices = _getPatternStartIndices(patternLines);
      (List<String>, List<int>)? alternativeRowPattern = _getAlternativePattern(patternLines);
      part2 += (alternativeRowPattern?.$2.where((x) => !oldRowPatternStartIndices.contains(x)).sum ?? 0) * 100;

      // Columns
      List<String> patternColumns = patternLines.first.codeUnits
          .mapIndexed((index, element) => patternLines.map((e) => e[index]).join(''))
          .toList();
      List<int> oldColumnPatternStartIndices = _getPatternStartIndices(patternColumns);
      (List<String>, List<int>)? alternativeColumnPattern = _getAlternativePattern(patternColumns);
      part2 += alternativeColumnPattern?.$2.where((x) => !oldColumnPatternStartIndices.contains(x)).sum ?? 0;
    }

    return 'Part 1: $part1\nPart 2: $part2';
  }

  List<int> _getPatternStartIndices(List<String> patternLines) {
    List<int> foundPatternStartIndices = [];

    bool foundPattern = true;
    while (foundPattern) {
      int? patternStart;
      String previousLine = patternLines[0];
      for (int y = 1; y < patternLines.length; y++) {
        String currentLine = patternLines[y];
        if (patternStart != null) {
          // Test if this is actually a reflection
          int reflectingLineIndex = patternStart - 1 - (y - patternStart);
          if (reflectingLineIndex < 0) break;
          String reflectingLine = patternLines[reflectingLineIndex];
          if (currentLine != reflectingLine) patternStart = null;
        }

        if (patternStart == null && currentLine == previousLine && !foundPatternStartIndices.contains(y)) patternStart = y;

        previousLine = currentLine;
      }

      if (patternStart != null) {
        foundPattern = true;
        foundPatternStartIndices.add(patternStart);
      } else {
        foundPattern = false;
      }
    }

    return foundPatternStartIndices;
  }

  (List<String>, List<int>)? _getAlternativePattern(List<String> patternLines) {
    List<int> originalStartIndices = _getPatternStartIndices(patternLines);

    for (int i = 0; i < patternLines.length; i++) {
      var patternLine1 = patternLines[i];
      for (int j = 0; j < patternLines.length; j++) {
        var patternLine2 = patternLines[j];
        if (patternLine2 == patternLine1) continue;

        int differences = 0;
        for (int charIndex = 0; charIndex < patternLine1.length; charIndex++) {
          if (patternLine1[charIndex] != patternLine2[charIndex]) differences++;
          if (differences > 1) break;
        }

        if (differences == 1) {
          // Two different lines can be made matching, we will test if this introduces a different pattern start index
          var patternLinesCloned = [...patternLines];
          patternLinesCloned[j] = patternLinesCloned[i];

          var modifiedPatternStartIndices = _getPatternStartIndices(patternLinesCloned);
          if (!modifiedPatternStartIndices.equals(originalStartIndices) && modifiedPatternStartIndices.isNotEmpty) {
            return (patternLinesCloned, modifiedPatternStartIndices);
          }
        }
      }
    }

    return null;
  }

}
