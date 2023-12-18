import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';
import 'package:h3x_devtools/solvers/helpers/grid.dart';

class Day17Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 17;

  @override
  String getSolution(String input) {
    List<String> rawGridLines = input.splitLines().toList();
    Grid<int> grid = Grid.generated(width: rawGridLines.first.length, height: rawGridLines.length, getValue: (x, y) {
      return int.parse(rawGridLines[y][x]);
    });

    // Part 1
    var path = grid.aStar(
      start: (x: 0, y: 0),
      end: (x: grid.width - 1, y: grid.height - 1),
      getTentativeGScore: (neighbor, path) {
        int value = grid.getValue(x: neighbor.x, y: neighbor.y);
        if (path.length < 5) return value;

        for (int i = 0; i <= path.length - 5; i++) {
          if ((path[i].x == path[i + 1].x &&
                  path[i + 1].x == path[i + 2].x &&
                  path[i + 2].x == path[i + 3].x &&
                  path[i + 3].x == path[i + 4].x) ||
              (path[i].y == path[i + 1].y &&
                  path[i + 1].y == path[i + 2].y &&
                  path[i + 2].y == path[i + 3].y &&
                  path[i + 3].y == path[i + 4].y)) {
            return 999999;
          }
        }

        return value;
      },
    );
    print(path);
    int part1 = path.skip(1).fold(0, (previousValue, element) => previousValue + grid.getValue(x: element.x, y: element.y));

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

}
