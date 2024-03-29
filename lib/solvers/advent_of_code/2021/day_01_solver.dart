import 'package:h3x_devtools/solvers/advent_of_code/2021/aoc_2021_solver.dart';

class Day01Solver extends AdventOfCode2021Solver {

  @override
  final int dayNumber = 1;
  
  @override
  String getSolution(String input) {
    List<int> measurements = input
      .split('\n')
      .where((rawMeasurement) => rawMeasurement.isNotEmpty)
      .map(int.parse)
      .toList();

    // part 1
    int nLargerThanPrevious = 0;
    int? previousValue;
    for (int measurement in measurements) {
      if (previousValue != null && measurement > previousValue) {
        nLargerThanPrevious++;
      }

      previousValue = measurement;
    }

    // part 2
    int nThreeMeasurementSlidingWindowLargerThanPrevious = 0;
    int? previousThreeMeasurementSlidingWindowValue;
    for (int i = 0; i < measurements.length - 2; i += 1) {
      int total = measurements[i] + measurements[i + 1] + measurements[i + 2];

      if (previousThreeMeasurementSlidingWindowValue != null && total > previousThreeMeasurementSlidingWindowValue) {
        nThreeMeasurementSlidingWindowLargerThanPrevious++;
      }

      previousThreeMeasurementSlidingWindowValue = total;
    }

    return 'Measurements larger than the previous: $nLargerThanPrevious\nThree-measurement sliding window sums larger than the previous: $nThreeMeasurementSlidingWindowLargerThanPrevious';
  }

}
