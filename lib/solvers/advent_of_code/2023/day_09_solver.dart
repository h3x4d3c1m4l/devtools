import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

class Day09Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 9;

  @override
  String getSolution(String input) {
    List<List<int>> inputLines = input.splitLines().map((line) => line.split(' ').parsedAsInts.toList()).toList();

    // Part 1
    var part1 = _getTotalOfInterpolation(inputLines);

    // Part 2
    var part2 = _getTotalOfInterpolation(inputLines.map((line) => line.reversed));

    return 'Part 1: $part1\nPart 2: $part2';
  }

  int _getTotalOfInterpolation(Iterable<Iterable<int>> numberLines) {
    var total = 0;
    for (var lineNumbers in numberLines) {
      List<List<int>> numberIncreaseSequences = [lineNumbers.toList()];

      // Prepare interpolation
      while (!numberIncreaseSequences.last.every((number) => number == 0)) {
        List<int> numberIncreaseSequence = [];

        var lastSeq = numberIncreaseSequences.last;
        for (int i = 0; i < (lastSeq.length - 1); i++) {
          numberIncreaseSequence.add(lastSeq[i + 1] - lastSeq[i]);
        }

        numberIncreaseSequences.add(numberIncreaseSequence);
      }

      // Interpolate
      int increaseNextBy = 0;
      for (var numberIncreaseSequence in numberIncreaseSequences.reversed) {
        increaseNextBy = numberIncreaseSequence.last + increaseNextBy;
        numberIncreaseSequence.add(increaseNextBy);
      }

      total += numberIncreaseSequences.first.last;
    }
    return total;
  }

}
