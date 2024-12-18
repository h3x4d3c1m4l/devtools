import 'package:h3x_devtools/solvers/advent_of_code/2024/aoc_2024_solver.dart';

class Day17Solver extends AdventOfCode2024Solver {

  @override
  final int dayNumber = 17;

  @override
  String getSolution(String input) {
    String splitNewline = input.contains('\r\n\r\n') ? '\r\n\r\n' : input.contains('\r\r') ? '\r\r' : '\n\n';
    List<String> inputParts = input.split(splitNewline);

    List<String> registers = inputParts[0].splitLines().toList();
    int registerA = int.parse(registers[0].split('Register A: ')[1]);
    int registerB = int.parse(registers[1].split('Register B: ')[1]);
    int registerC = int.parse(registers[2].split('Register C: ')[1]);

    List<int> instructions = inputParts[1].split('Program: ')[1].split(',').toIntList();

    // Part 1
    List<int> output = _runProgram(instructions, registerA, registerB, registerC);

    return 'Program output: ${output.join(',')}';
  }

  int test(int getal, List<int> instructions, int initialRegisterA, int initialRegisterB, int initialRegisterC) {
    List<int> x =  _runProgram(instructions, initialRegisterA, initialRegisterB, initialRegisterC);
    if (x.length < instructions.length) {
      return -1;
    } else if (x.length > instructions.length) {
      return 1;
    } else {
      for (int i = 0; i < instructions.length; i++) {
        if (x[i] < instructions[i]) return -1;
        if (x[i] > instructions[i]) return 1;
      }
    }

    return 0;
  }

  List<int> _runProgram(List<int> instructions, int initialRegisterA, int initialRegisterB, int initialRegisterC) {
    int registerA = initialRegisterA, registerB = initialRegisterB, registerC = initialRegisterC;
    int instructionPointer = 0;
    List<int> output = [];

    while (instructionPointer <= instructions.length - 2) {
      int operand = instructions[instructionPointer + 1];
      int comboOperand = _getComboOperandValue(registerA, registerB, registerC, operand);
      bool updateInstructionPointer = true;

      switch (instructions[instructionPointer]) {
        case 0: // adv
          registerA ~/= pow(2, comboOperand);
        case 1: // bxl
          registerB ^= operand;
        case 2: // bst
          registerB = comboOperand % 8;
        case 3: // jnz
          if (registerA != 0) {
            instructionPointer = operand;
            updateInstructionPointer = false;
          }
        case 4: // bxc
          registerB ^= registerC;
        case 5: // out
          output.add(comboOperand % 8);
        case 6: // bdv
          registerB = registerA ~/ pow(2, comboOperand);
        case 7: // cdv
          registerC = registerA ~/ pow(2, comboOperand);
        default:
          throw Exception('Could not parse instruction');
      }

      if (updateInstructionPointer) instructionPointer += 2;
    }

    return output;
  }

  int _getComboOperandValue(int registerA, int registerB, int registerC, int operand) {
    return switch (operand) {
      >= 0 && <= 3 => operand,
      4 => registerA,
      5 => registerB,
      6 => registerC,
      7 => throw Exception('Reserved, should not be seen in valid programs'),
      _ => throw Exception('Invalid'),
    };
  }

}
