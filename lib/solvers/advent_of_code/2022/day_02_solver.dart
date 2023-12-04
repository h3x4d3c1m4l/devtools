import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';
import 'package:h3x_devtools/solvers/extensions.dart';

class Day02Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 2;
  
  @override
  String getSolution(String input) {
    List<String> instructions = input.splitLines().toList();

    // part 1
    int totalAssumedStrategyGuidePoints = 0;
    for (String instruction in instructions) {
      List<String> instructionArguments = instruction.split(' ');
      totalAssumedStrategyGuidePoints += _getAssumedPoints(instructionArguments[0], instructionArguments[1]);
    }

    // part 2
    int totalActualStrategyGuidePoints = 0;
    for (String instruction in instructions) {
      List<String> instructionArguments = instruction.split(' ');
      totalActualStrategyGuidePoints += _getActualPoints(instructionArguments[0], instructionArguments[1]);
    }

    return 'Strategy guide assumed total score: $totalAssumedStrategyGuidePoints\nStrategy guide actual total score: $totalActualStrategyGuidePoints';
  }

  int _getAssumedPoints(String opponentChoice, String myChoice) {
    // points for choice
    int score = myChoice == 'X' ? 1 : myChoice == 'Y' ? 2 : 3;

    // points for win/loss/draw
    if (opponentChoice == 'A' && myChoice == 'X') { // rock, rock
      score += 3;
    } else if (opponentChoice == 'A' && myChoice == 'Y') { // rock, paper
      score += 6;
    } else if (opponentChoice == 'B' && myChoice == 'Y') { // paper, paper
      score += 3;
    } else if (opponentChoice == 'B' && myChoice == 'Z') { // paper, scissors
      score += 6;
    } else if (opponentChoice == 'C' && myChoice == 'X') { // scissors, rock
      score += 6;
    } else if (opponentChoice == 'C' && myChoice == 'Z') { // scissors, scissors
      score += 3;
    }

    return score;
  }

  int _getActualPoints(String opponentChoice, String endNeeded) {
    if (opponentChoice == 'A' && endNeeded == 'X') { // rock, lose
      return _getAssumedPoints(opponentChoice, 'Z');
    } else if (opponentChoice == 'A' && endNeeded == 'Y') { // rock, draw
      return _getAssumedPoints(opponentChoice, 'X');
    } else if (opponentChoice == 'A' && endNeeded == 'Z') { // rock, win
      return _getAssumedPoints(opponentChoice, 'Y');
    } else if (opponentChoice == 'B' && endNeeded == 'X') { // paper, lose
      return _getAssumedPoints(opponentChoice, 'X');
    } else if (opponentChoice == 'B' && endNeeded == 'Y') { // paper, draw
      return _getAssumedPoints(opponentChoice, 'Y');
    } else if (opponentChoice == 'B' && endNeeded == 'Z') { // paper, win
      return _getAssumedPoints(opponentChoice, 'Z');
    } else if (opponentChoice == 'C' && endNeeded == 'X') { // scissors, lose
      return _getAssumedPoints(opponentChoice, 'Y');
    } else if (opponentChoice == 'C' && endNeeded == 'Y') { // scissors, draw
      return _getAssumedPoints(opponentChoice, 'Z');
    } else if (opponentChoice == 'C' && endNeeded == 'Z') { // scissors, win
      return _getAssumedPoints(opponentChoice, 'X');
    }

    return 0;
  }

}
