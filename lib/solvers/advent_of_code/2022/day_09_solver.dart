import 'dart:core';

import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day09Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 9;

  @override
  String getSolution(String input) {
    List<(String instruction, int count)> movementInstructions = input
        .splitLines()
        .map((rawInstructionLine) => rawInstructionLine.split(' '))
        .map((rawInstruction) => (rawInstruction[0], int.parse(rawInstruction[1])))
        .toList(growable: false);

    // part 1
    int positionsVisitedByTail = getAmountOfPositionsVisitedByTail(movementInstructions, 2);

    // part 2
    int positionsVisitedByTail10Knots = getAmountOfPositionsVisitedByTail(movementInstructions, 10);

    return 'Positions visited part 1: $positionsVisitedByTail\nPositions visited part 2: $positionsVisitedByTail10Knots';
  }

  int getAmountOfPositionsVisitedByTail(List<(String instruction, int count)> movementInstructions, int numberOfKnots) {
    Set<(int x, int y)> positionsVisitedByTail = {};
    List<(int x, int y)> knots = List.filled(numberOfKnots, const (0, 0));
    for (var (String instruction, int count) in movementInstructions) {
      for (int i = 0; i < count; i++) {
        // move head
        knots[0] = switch (instruction) {
          'L' => (knots[0].$1 - 1, knots[0].$2),
          'R' => (knots[0].$1 + 1, knots[0].$2),
          'U' => (knots[0].$1, knots[0].$2 + 1),
          'D' => (knots[0].$1, knots[0].$2 - 1),
          _ => throw Exception('Unknown instruction [$instruction]'),
        };

        // let tail follow
        for (int i = 1; i < knots.length; i++) {
          int deltaX = knots[i - 1].$1 - knots[i].$1;
          int deltaY = knots[i - 1].$2 - knots[i].$2;
          if (deltaX.abs() == 2 && deltaY == 0) {
            knots[i] = (knots[i].$1 + deltaX ~/ 2, knots[i].$2);
          } else if (deltaX == 0 && deltaY.abs() == 2) {
            knots[i] = (knots[i].$1, knots[i].$2 + deltaY ~/ 2);
          } else if (deltaX.abs() == 2 && deltaY.abs() == 1) {
            knots[i] = (knots[i].$1 + deltaX ~/ 2, knots[i].$2 + deltaY);
          } else if (deltaX.abs() == 1 && deltaY.abs() == 2) {
            knots[i] = (knots[i].$1 + deltaX, knots[i].$2 + deltaY ~/ 2);
          } else if (deltaX.abs() == 2 && deltaY.abs() == 2) {
            knots[i] = (knots[i].$1 + deltaX ~/ 2, knots[i].$2 + deltaY ~/ 2);
          }
        }

        positionsVisitedByTail.add(knots.last);
      }
    }

    return positionsVisitedByTail.length;
  }

}
