import 'dart:core';

import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';

class Day10Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 10;
  
  @override
  String getSolution(String input) {
    List<(String, int?)> cpuInstructions = input
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((rawInstructionLine) => rawInstructionLine.split(' '))
        .map((rawInstruction) => (rawInstruction[0], rawInstruction.length == 2 ? int.parse(rawInstruction[1]) : null))
        .toList(growable: false);
    
    // part 1
    int cycle = 0;
    int signalStrengthSum = 0;
    int xRegisterValue = 1;
    for (var (String instruction, int? count) in cpuInstructions) {
      cycle++;
      signalStrengthSum += getSignalStrengthSumForCycle(cycle, xRegisterValue);
      
      if (instruction == 'addx') {
        cycle++;
        signalStrengthSum += getSignalStrengthSumForCycle(cycle, xRegisterValue);
        xRegisterValue += count!;
      }

      if (cycle > 220) {
        break;
      }
    }

    // part 2
    cycle = 0;
    xRegisterValue = 1;
    List<String> pixelLines = List.filled(6, '........................................');
    updateCrtDisplay(pixelLines, cycle, xRegisterValue);
    for (var (String instruction, int? count) in cpuInstructions) {
      cycle++;
      
      updateCrtDisplay(pixelLines, cycle, xRegisterValue);
      
      if (instruction == 'addx') {
        cycle++;
        xRegisterValue += count!;
        updateCrtDisplay(pixelLines, cycle, xRegisterValue);
      }

      if (cycle >= 240) {
        break;
      }
    }

    return 'Signal strength sum: $signalStrengthSum\nCRT display:\n${pixelLines.join('\n')}';
  }

  int getSignalStrengthSumForCycle(int cycle, int xRegisterValue) {
    if (cycle >= 20 && (cycle - 20) % 40 == 0) {
      return cycle * xRegisterValue;
    }
    return 0;
  }
  
  void updateCrtDisplay(List<String> pixelLines, int cycle, int xRegisterValue) {
    int crtRow = cycle ~/ 40;
    int crtColumn = cycle % 40;

    if (crtColumn >= (xRegisterValue - 1) && crtColumn <= (xRegisterValue + 1)) {
      pixelLines[crtRow] = pixelLines[crtRow].replaceRange(crtColumn, crtColumn + 1, '#');
    }
  }

}
