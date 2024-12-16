import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

typedef _Robot = ({Coordinates start, int xPerSecond, int yPerSecond});

class Day14Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 14;

  @override
  String getSolution(String input) {
    List<_Robot> robots = input.splitLines().map((line) {
      List<String> lineSplit = line.split(' ');
      List<int> startCoordinates = lineSplit[0].substring(2).split(',').map(int.parse).toList();
      List<int> movementPerSecond = lineSplit[1].substring(2).split(',').map(int.parse).toList();
      return (
        start: Coordinates(startCoordinates[0], startCoordinates[1]),
        xPerSecond: movementPerSecond[0],
        yPerSecond: movementPerSecond[1],
      );
    }).toList();

    // Keep into account the example has a smaller area.
    int fieldWidth = robots.length == 12 ? 11 : 101;
    int fieldHeight = robots.length == 12 ? 7 : 103;

    // Part 1
    int qLeftTop = 0, qRightTop = 0, qLeftBottom = 0, qRightBottom = 0;
    for (_Robot robot in robots) {
      int endX = (robot.start.x + (robot.xPerSecond * 100)) % fieldWidth;
      int endY = (robot.start.y + (robot.yPerSecond * 100)) % fieldHeight;

      if (endX < (fieldWidth - 1) ~/ 2) {
        if (endY < (fieldHeight - 1) ~/ 2) {
          qLeftTop++;
        } else if (endY > (fieldHeight - 1) ~/ 2) {
          qRightTop++;
        }
      } else if (endX > (fieldWidth - 1) ~/ 2) {
        if (endY < (fieldHeight - 1) ~/ 2) {
          qLeftBottom++;
        } else if (endY > (fieldHeight - 1) ~/ 2) {
          qRightBottom++;
        }
      }
    }
    int safetyScore = qLeftTop * qRightTop * qLeftBottom * qRightBottom;

    return 'Safety score: $safetyScore';
  }

}
