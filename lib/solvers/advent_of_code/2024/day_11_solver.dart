import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day11Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 11;

  @override
  String getSolution(String input) {
    List<int> initialArrangement = input.split(' ').map(int.parse).toList();

    // Part 1
    List<int> currentArrangement = initialArrangement.toList();
    for (int blinked = 0; blinked < 25; blinked++) {
      List<int> tmpArrangement = [];
      for (int stone in currentArrangement) {
        if (stone == 0) {
          tmpArrangement.add(1);
        } else {
          List<int> stoneDigits = stone.digits;
          if (stoneDigits.length.isEven) {
            String leftNumber = stoneDigits.take(stoneDigits.length ~/ 2).join();
            String rightNumber = stoneDigits.skip(stoneDigits.length ~/ 2).join();
            tmpArrangement..add(int.parse(leftNumber))..add(int.parse(rightNumber));
          } else {
            tmpArrangement.add(stone * 2024);
          }
        }
      }

      currentArrangement = tmpArrangement;
    }

    return 'Stone count after blinking 25 times: ${currentArrangement.length}';
  }

}
