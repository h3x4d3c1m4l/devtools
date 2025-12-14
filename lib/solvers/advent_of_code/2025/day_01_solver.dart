import 'package:h3x_devtools/solvers/advent_of_code/2025/aoc_2025_solver.dart';

enum _RotationDirection { left, right }

typedef _Rotation = ({_RotationDirection direction, int count});

class Day01Solver extends AdventOfCode2025Solver {

  @override
  final int dayNumber = 1;

  @override
  String getSolution(String input) {
    List<_Rotation> rotationValues = input.splitLines().map((line) => (
      direction: switch (line[0]) {
        'L' => _RotationDirection.left,
        'R' => _RotationDirection.right,
        _ => throw Exception('Unexpected input'),
      },
      count: int.parse(line.substring(1)),
    )).toList();

    // Part 1
    int pointedAtZero = 0;
    int currentDialPosition = 50;
    for (_Rotation rotationValue in rotationValues) {
      switch (rotationValue.direction) {
        case _RotationDirection.left:
          currentDialPosition -= rotationValue.count;
        case _RotationDirection.right:
          currentDialPosition += rotationValue.count;
      }

      if (currentDialPosition < 0) {
        while (currentDialPosition < 0) {
          currentDialPosition = 99 - (currentDialPosition.abs() - 1);
        }
      } else if (currentDialPosition > 99) {
        while (currentDialPosition > 99) {
          currentDialPosition -= 100;
        }
      }
    }

    // Part 2
    // TODO

    return 'Rotated past zero: $pointedAtZero';
  }

}
