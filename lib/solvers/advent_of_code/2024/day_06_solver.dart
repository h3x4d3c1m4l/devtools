import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day06Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 6;

  @override
  String getSolution(String input) {
    Grid<String> grid = Grid.fromString(input, (value) => value);

    // Part 1
    Coordinates pGuard = grid.getCoordinatesOf('^')!;
    CardinalDirection guardDirection = CardinalDirection.north;
    Set<Coordinates> steps = {pGuard};
    while (pGuard.canGoCDirection(guardDirection)) {
      Coordinates pGuardAfterStep = pGuard.goToCDirection(guardDirection);
      if (grid[pGuardAfterStep].obj == '#') {
        guardDirection = guardDirection.clockwiseNext;
      } else {
        steps.add(pGuardAfterStep);
        pGuard = pGuardAfterStep;
      }
    }


    return 'Guard steps: ${steps.length}, Possible barrier locations: Not possible yet';
  }

}
