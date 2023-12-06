import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/extensions.dart';
import 'package:h3x_devtools/solvers/maths.dart';

class Day06Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 6;

  @override
  String getSolution(String input) {
    List<String> inputLines = input.splitLines().toList();
    List<int> times = inputLines[0].split(' ').skip(1).where((s) => s.isNotEmpty).map(int.parse).toList();
    List<int> recordDistances = inputLines[1].split(' ').skip(1).where((s) => s.isNotEmpty).map(int.parse).toList();
    assert(times.length == recordDistances.length, 'Time and distance array lengths expected to be equal');

    // Part 1
    int part1 = 1;
    for (int i = 0; i < times.length; i++) {
      int time = times[i], recordDistance = recordDistances[i];

      int recordBroken = 0;
      for (int buttonHeld = 1; buttonHeld < time; buttonHeld++) {
        int distanceTraveled = (time - buttonHeld) * buttonHeld;
        distanceTraveled = time * buttonHeld - buttonHeld * buttonHeld;
        if (distanceTraveled > recordDistance) recordBroken++;
      }

      part1 *= recordBroken;
    }

    // Part 2
    int time = int.parse(inputLines[0].split(' ').skip(1).where((s) => s.isNotEmpty).join(''));
    int recordDistance = int.parse(inputLines[1].split(' ').skip(1).where((s) => s.isNotEmpty).join(''));
    var buttonPressTimeMinAndMax = abcFormula(-1, time, -recordDistance);
    int part2 = buttonPressTimeMinAndMax.$2.floor() - buttonPressTimeMinAndMax.$1.floor();

    return 'Part 1: $part1\nPart 2: $part2';
  }

}
