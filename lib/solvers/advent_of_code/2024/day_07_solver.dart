import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

typedef _Equation = ({int total, List<int> factors});

class Day07Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 7;

  @override
  String getSolution(String input) {
    List<_Equation> equations = input.splitLines().map((line) {
      List<String> lineSplit = line.split(': ');
      return (
        total: int.parse(lineSplit[0]),
        factors: lineSplit[1].split(' ').map(int.parse).toList(),
      );
    }).toList();

    // Part 1
    int validEqs = 0;
    for (_Equation equation in equations) {
      if (_canBeTrue(equation.total, equation.factors)) {
        validEqs += equation.total;
      }
    }

    // Part 2
    int validEqsWith3Ops = 0;
    for (_Equation equation in equations) {
      if (_canBeTrueWith3Ops(equation.total, equation.factors)) {
        validEqsWith3Ops += equation.total;
      }
    }

    return 'Valid with 2 operators: $validEqs, Valid with 3 operators $validEqsWith3Ops';
  }

  bool _canBeTrue(int total, List<int> factors) {
    if (factors.length == 2) {
      return factors[0] + factors[1] == total || factors[0] * factors[1] == total;
    } else {
      return _canBeTrue(total, [factors[0] * factors[1], ...factors.skip(2)]) ||
          _canBeTrue(total, [factors[0] + factors[1], ...factors.skip(2)]);
    }
  }

  bool _canBeTrueWith3Ops(int total, List<int> factors) {
    if (factors.length == 2) {
      return factors[0] + factors[1] == total ||
          factors[0] * factors[1] == total ||
          int.parse('${factors[0]}${factors[1]}') == total;
    } else {
      return _canBeTrueWith3Ops(total, [factors[0] * factors[1], ...factors.skip(2)]) ||
          _canBeTrueWith3Ops(total, [factors[0] + factors[1], ...factors.skip(2)]) ||
          _canBeTrueWith3Ops(total, [int.parse('${factors[0]}${factors[1]}'), ...factors.skip(2)]);
    }
  }

}
