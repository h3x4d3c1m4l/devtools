import 'package:characters/characters.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day15Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 15;

  @override
  String getSolution(String input) {
    String splitNewline = input.contains('\r\n\r\n') ? '\r\n\r\n' : input.contains('\r\r') ? '\r\r' : '\n\n';
    List<String> inputParts = input.split(splitNewline);
    Grid<String> grid = Grid.fromString(inputParts[0], (tile) => tile);
    String movements = inputParts[1].replaceAll('\r', '').replaceAll('\n', '');

    // Part 1
    Coordinates robot = grid.getCoordinatesOfFirstWhere((tile) => tile == '@')!;
    for (String movement in movements.characters) {
      CardinalDirection direction = switch (movement) {
        '>' => CardinalDirection.east,
        '<' => CardinalDirection.west,
        '^' => CardinalDirection.north,
        'v' => CardinalDirection.south,
        _ => throw Exception('Unsupported movement operation [$movement]'),
      };

      robot = moveDirection(grid, robot, direction);
    }

    int sumOfGpsCoordinates = 0;
    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        if (grid[Coordinates(x, y)].obj == 'O') {
          sumOfGpsCoordinates += 100 * y + x;
        }
      }
    }

    return 'Sum of GPS coordinates: $sumOfGpsCoordinates';
  }

  Coordinates moveDirection(Grid<String> grid, Coordinates robot, CardinalDirection direction) {
    Coordinates robotNextStep = robot.goToCDirection(direction);
    String nextStepValue = grid.getValue(robotNextStep);
    if (nextStepValue == '.') {
      // Most happy flow: Robot can move freely.
      grid
        ..setValue(robotNextStep, '@')
        ..setValue(robot, '.');
      return robotNextStep;
    } else if (nextStepValue == '#') {
      // Most unhappy flow: Robot can't move at all.
      return robot;
    } else {
      // Less happy flow: Robot can either move box or can't move at all.
      Coordinates lastPos = robotNextStep;
      while (lastPos.canGoCDirection(direction)) {
        Coordinates nextStep = lastPos.goToCDirection(direction);
        if (grid.getValue(nextStep) == '.') {
          // We can move by moving all boxes.
          grid
            ..setValue(nextStep, 'O')
            ..setValue(robotNextStep, '@')
            ..setValue(robot, '.');
          return robotNextStep;
        } else if (grid.getValue(nextStep) == 'O') {
          // We still might be able to move.
          lastPos = nextStep;
        } else {
          // We can't move.
          return robot;
        }
      }
      return robot;
    }
  }

}
