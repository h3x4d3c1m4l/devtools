import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';

class Day06Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 6;
  
  @override
  String getSolution(String input) {
    // part 1
    int? charactersProcessedPart1 = _getDistinctCharactersIndex(input, 4);

    // part 2
    int? charactersProcessedPart2 = _getDistinctCharactersIndex(input, 14);
    
    return 'Characters processed part 1: ${charactersProcessedPart1 ?? 'Not found'}\nCharacters processed part 2: ${charactersProcessedPart2 ?? 'Not found'}';
  }

  int? _getDistinctCharactersIndex(String input, int numberOfDistinctCharacters) {
    int endIndex = input.length - numberOfDistinctCharacters;
    int i = 0;
    while (i < endIndex) {
      int? skip;
      for (int j = 0; j < numberOfDistinctCharacters; j++) {
        for (int z = j + 1; z < numberOfDistinctCharacters; z++) {
          if (input[i + j] == input[i + z]) {
            skip = j + 1;
            break;
          }
        }

        if (skip != null) {
          i += skip;
          break;
        }
      }

      if (skip == null) {
        return i + numberOfDistinctCharacters;
      }
    }

    return null;
  }

}
