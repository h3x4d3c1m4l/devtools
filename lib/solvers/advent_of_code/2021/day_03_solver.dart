import 'package:h3x_devtools/solvers/advent_of_code/2021/aoc_2021_solver.dart';

class Day03Solver extends AdventOfCode2021Solver {

  @override
  final int dayNumber = 3;

  @override
  String getSolution(String input) {
    Grid<String> binaryGrid = Grid.fromString(input, (value) => value);

    // Part 1
    int gammaRate = 0;
    for (int i = 0; i < binaryGrid.width; i++) {
      int oneOrZero = binaryGrid.columns[i].map((column) => int.parse(column.obj)).average.round();
      gammaRate |= oneOrZero << (binaryGrid.width - i - 1);
    }
    int epsilonRate = ~gammaRate & ((1 << binaryGrid.width) - 1);
    int powerConsumption = gammaRate * epsilonRate;

    // Part 2
    List<int> o2GenRatings = input.splitLines().map((line) => int.parse(line, radix: 2)).toList();
    for (int i = 0; i < binaryGrid.width && o2GenRatings.length > 1; i++) {
      int oneOrZero = o2GenRatings.map((number) => (number >> (binaryGrid.width - i - 1)) & 1).average.round();
      o2GenRatings = o2GenRatings.where((rating) => (rating >> (binaryGrid.width - i - 1)) & 1 == oneOrZero).toList();

      if (o2GenRatings.length == 1) break;
    }

    List<int> co2ScrubRatings = input.splitLines().map((line) => int.parse(line, radix: 2)).toList();
    for (int i = 0; i < binaryGrid.width && co2ScrubRatings.length > 1; i++) {
      int oneOrZero = co2ScrubRatings.map((number) => (number >> (binaryGrid.width - i - 1)) & 1).average.round();
      co2ScrubRatings = co2ScrubRatings.whereNot((rating) => (rating >> (binaryGrid.width - i - 1)) & 1 == oneOrZero).toList();
    }

    int lifeSupportRating = o2GenRatings.single * co2ScrubRatings.single;

    return 'Power consumption: $powerConsumption\nLife support rating: $lifeSupportRating';
  }

}
