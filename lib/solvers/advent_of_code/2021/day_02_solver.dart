import 'package:h3x_devtools/solvers/advent_of_code/2021/aoc_2021_solver.dart';

class Day02Solver extends AdventOfCode2021Solver {

  @override
  final int dayNumber = 2;
  
  @override
  String getSolution(String input) {
    List<(String instruction, int count)> instructions = input
      .split('\n')
      .where((rawMeasurement) => rawMeasurement.isNotEmpty)
      .map((rawInstruction) => rawInstruction.split(' '))
      .map((splittedInstruction) => (splittedInstruction[0], int.parse(splittedInstruction[1])))
      .toList();

    // part 1
    int horizontalPosition = 0, depth = 0;
    for (var (String instruction, int count) in instructions) {
      switch (instruction) {
        
        case 'forward':
          horizontalPosition += count;
        case 'down':
          depth += count;
        case 'up':
          depth -= count;

      }
    }
    int horizontalPositionTimesDepth = horizontalPosition * depth;

    // part 2
    int aim = 0;
    horizontalPosition = 0;
    depth = 0;
    for (var (String instruction, int count) in instructions) {
      switch (instruction) {
        
        case 'forward':
          horizontalPosition += count;
          depth += aim * count;
        case 'down':
          aim += count;
        case 'up':
          aim -= count;

      }
    }
    int horizontalPositionTimesDepthPart2 = horizontalPosition * depth;

    return 'Horizontal position times final depth (part 1): $horizontalPositionTimesDepth\nHorizontal position times final depth (part 2): $horizontalPositionTimesDepthPart2';
  }

}
