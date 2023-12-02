import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';

class Day04Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 4;
  
  @override
  String getSolution(String input) {
    List<(String rawAssignment1, String rawAssignment2)> rawAssignmentPairs = input
        .split('\n')
        .where((rawAssignmentPair) => rawAssignmentPair.isNotEmpty)
        .map((rawAssignmentPair) {
          List<String> rawAssignments = rawAssignmentPair.split(',');
          return (rawAssignments[0], rawAssignments[1]);
        }).toList();

    // part 1
    int nAssignmentPairsFullOverlap = 0;
    for (var (String rawAssignment1, String rawAssignment2) in rawAssignmentPairs) {
      List<int> assignment1 =
          rawAssignment1.split('-').map(int.parse).toList();
      List<int> assignment2 =
          rawAssignment2.split('-').map(int.parse).toList();

      if ((assignment1[0] >= assignment2[0] && assignment1[1] <= assignment2[1]) ||
          (assignment2[0] >= assignment1[0] && assignment2[1] <= assignment1[1])) {
        nAssignmentPairsFullOverlap++;
      }
    }

    // part 2
    int nAssignmentPairsPartialOverlap = 0;
    for (var (String rawAssignment1, String rawAssignment2) in rawAssignmentPairs) {
      List<int> assignment1 =
          rawAssignment1.split('-').map(int.parse).toList();
      List<int> assignment2 =
          rawAssignment2.split('-').map(int.parse).toList();

      if ((assignment1[0] >= assignment2[0] && assignment1[0] <= assignment2[1]) ||
          (assignment1[1] >= assignment2[0] && assignment1[1] <= assignment2[1]) ||
          (assignment2[0] >= assignment1[0] && assignment2[0] <= assignment1[1]) ||
          (assignment2[1] >= assignment1[0] && assignment2[1] <= assignment1[1])) {
        nAssignmentPairsPartialOverlap++;
      }
    }

    return 'Assignment pairs with full overlap: $nAssignmentPairsFullOverlap\nAssignment pairs with partial overlap: $nAssignmentPairsPartialOverlap';
  }

}
