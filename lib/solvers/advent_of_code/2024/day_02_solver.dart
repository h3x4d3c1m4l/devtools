import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day02Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 2;

  @override
  String getSolution(String input) {
    List<List<int>> leveledReports = input.splitLines().map((line) => line.split(' ').parsedAsInts.toList()).toList();

    // Part 1
    int safeReports = _getSaveReports(leveledReports, false);

    // Part 2
    int safeReportsWith = _getSaveReports(leveledReports, true);

    return 'Safe reports: $safeReports, Safe reports when allowing one error: $safeReportsWith';
  }

  int _getSaveReports(List<List<int>> leveledReports, bool allowInvalidLevel) {
    return leveledReports.where((report) {
      bool result = _getReportSafe(report);
      int i = 0;
      while (!result && allowInvalidLevel && i < report.length) {
        result = _getReportSafe(report.toList()..removeAt(i));
        i++;
      }
      return result;
    }).length;
  }

  bool _getReportSafe(List<int> report) {
    int maxInc = 0, maxDec = 0;

    for (int i = 0; i < report.length - 1; i++) {
      var currentLevel = report[i];
      var nextLevel = report[i + 1];

      int inc = nextLevel - currentLevel;
      maxInc = inc > 0 ? max(maxInc, inc) : maxInc;
      maxDec = inc < 0 ? max(maxDec, inc.abs()) : maxDec;

      if (inc == 0 || !((maxInc == 0 && maxDec >= 1 && maxDec <= 3) || (maxInc >= 1 && maxInc <= 3 && maxDec == 0))) {
        return false;
      }
    }

    return true;
  }

}
