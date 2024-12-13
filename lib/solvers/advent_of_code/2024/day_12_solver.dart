import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day12Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 12;

  @override
  String getSolution(String input) {
    Grid<String> grid = Grid.fromString(input, (value) => value);

    // Part 1
    Map<String, int> areaSizes = {}, perimeterLengths = {};
    int currentAreaNameChar = 97;
    for (int x = 0; x < grid.width; x++) {
      for (int y = 0; y < grid.height; y++) {
        Coordinates coordinates = Coordinates(x, y, grid);
        Cell<String> cell = grid[coordinates];

        // Area size
        if (!areaSizes.containsKey(cell.obj)) {
          // Because some area names can be used for multiple areas, make the area names unique.
          grid.floodFill4Way(coordinates, cell.obj, String.fromCharCode(currentAreaNameChar));
          currentAreaNameChar++;

          areaSizes[cell.obj] = 1;
          perimeterLengths[cell.obj] = 0;
        } else {
          areaSizes[cell.obj] = areaSizes[cell.obj]! + 1;
        }

        // Perimeter length
        for (CardinalDirection direction in CardinalDirection.values) {
          if (!coordinates.canGoCDirection(direction)) {
            perimeterLengths[cell.obj] = perimeterLengths[cell.obj]! + 1;
          } else {
            Coordinates neighbor = coordinates.goToCDirection(direction);
            if (grid[neighbor].obj != cell.obj) {
              perimeterLengths[cell.obj] = perimeterLengths[cell.obj]! + 1;
            }
          }
        }
      }
    }
    int price1 = areaSizes.keys.map((key) => areaSizes[key]! * perimeterLengths[key]!).sum;

    return 'Part 1 price: $price1';
  }

}
