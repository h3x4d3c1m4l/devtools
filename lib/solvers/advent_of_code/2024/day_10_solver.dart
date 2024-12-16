import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day10Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 10;

  @override
  String getSolution(String input) {
    Grid<int> grid = Grid.fromString(input, int.parse);

    // Part 1
    int sumOfScores = 0;
    for (Coordinates coordinates in grid.coordinatesOf(0)) {
      sumOfScores += _getHikingScore(grid, coordinates).length;
    }

    // Part 2
    int alternativeSumOfScores = 0;
    for (Coordinates coordinates in grid.coordinatesOf(0)) {
      alternativeSumOfScores += _getAlternativeHikingScore(grid, coordinates);
    }

    return 'Sum of scores: $sumOfScores, alternative sum of scores: $alternativeSumOfScores';
  }

  Set<Coordinates> _getHikingScore(Grid<int> grid, Coordinates startCoordinates) {
    int startValue = grid[startCoordinates].obj;
    Set<Coordinates> validTrailEnds = {};
    for (CardinalDirection direction in CardinalDirection.values) {
      if (startCoordinates.canGoCDirection(direction)) {
        Coordinates nextStep = startCoordinates.goToCDirection(direction);
        int nextValue = grid[nextStep].obj;
        if (nextValue == startValue + 1) {
          if (nextValue == 9) {
            validTrailEnds.add(nextStep);
          } else {
            validTrailEnds.addAll(_getHikingScore(grid, nextStep));
          }
        }
      }
    }
    return validTrailEnds;
  }

  int _getAlternativeHikingScore(Grid<int> grid, Coordinates startCoordinates) {
    int startValue = grid[startCoordinates].obj;
    int totalRating = 0;
    for (CardinalDirection direction in CardinalDirection.values) {
      if (startCoordinates.canGoCDirection(direction)) {
        Coordinates nextStep = startCoordinates.goToCDirection(direction);
        int nextValue = grid[nextStep].obj;
        if (nextValue == startValue + 1) {
          if (nextValue == 9) {
            totalRating++;
          } else {
            totalRating += _getAlternativeHikingScore(grid, nextStep);
          }
        }
      }
    }
    return totalRating;
  }

}
