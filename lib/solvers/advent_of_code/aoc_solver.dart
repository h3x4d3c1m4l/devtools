import 'package:h3x_devtools/solvers/solver.dart';

abstract class AdventOfCodeSolver extends Solver<String, String> {

  int get dayNumber;
  int get yearNumber;

  @override
  String get challengeUrl => 'https://adventofcode.com/$yearNumber/day/$dayNumber';

  @override
  String get solverCodeFilename => 'day_${dayNumber.toString().padLeft(2, '0')}_solver.dart';

  @override
  String get solverCodeGitHubUrl => 'https://github.com/h3x4d3c1m4l/devtools/tree/main/lib/solvers/advent_of_code/$yearNumber/$solverCodeFilename';

}
