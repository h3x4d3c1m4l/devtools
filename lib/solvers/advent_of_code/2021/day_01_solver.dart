import 'package:aoc22/solvers/solver.dart';

class Day01Solver extends Solver<String, String> {

  @override
  String get problemUrl => 'https://adventofcode.com/2021/day/1';

  @override
  String get solverCodeFilename => 'day_01_solver.dart';
  
  @override
  String getSolution(String input) {
    List<int> measurements = input
      .split('\n')
      .where((rawMeasurement) => rawMeasurement.isNotEmpty)
      .map((rawMeasurement) => int.parse(rawMeasurement))
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
