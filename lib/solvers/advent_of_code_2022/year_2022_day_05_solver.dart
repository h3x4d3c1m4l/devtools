import 'dart:collection';

import 'package:aoc22/solvers/solver.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:tuple/tuple.dart';

class Year2022Day05Solver extends Solver<String, String> {

  @override
  String get dartCodeFilename => 'year_2022_day_05_solver.dart';
  
  @override
  String getSolution(String input) {
    List<String> lines = input.split('\n').where((line) => line.isNotEmpty).toList(growable: false);
    List<ListQueue<String>> crateStacks;
    List<Tuple3<int, int, int>> instructions = _parseInstructions(lines);

    // part 1
    crateStacks = _getInitialStacksFromInput(lines);
    for (Tuple3<int, int, int> instruction in instructions) {
      int nCrates = instruction.item1;
      int fromCrateStack = instruction.item2;
      int toCrateStack = instruction.item3;

      // process crate move
      for (int i = 0; i < nCrates; i++) {
        String crate = crateStacks[fromCrateStack - 1].removeFirst();
        crateStacks[toCrateStack - 1].addFirst(crate);
      }
    }
    String part1TopCrates = crateStacks.map((crateStack) => crateStack.first).join();

    // part 2
    crateStacks = _getInitialStacksFromInput(lines);
    for (Tuple3<int, int, int> instruction in instructions) {
      int nCrates = instruction.item1;
      int fromCrateStack = instruction.item2;
      int toCrateStack = instruction.item3;

      // process crate move
      List<String> crates = [];
      for (int i = 0; i < nCrates; i++) {
        String crate = crateStacks[fromCrateStack - 1].removeFirst();
        crates.add(crate);
      }
      for (int i = nCrates - 1; i >= 0; i--) {
        crateStacks[toCrateStack - 1].addFirst(crates[i]); 
      }
    }
    String part2TopCrates = crateStacks.map((crateStack) => crateStack.first).join();

    return 'Part 1 top crates: $part1TopCrates\nPart 2 top crates: $part2TopCrates';
  }

  List<Tuple3<int, int, int>> _parseInstructions(List<String> inputLines) {
    List<Tuple3<int, int, int>> instructions = [];

    for (String inputLine in inputLines) {
      if (!inputLine.startsWith('move')) {
        continue;
      }

      // parse line
      final scanner = StringScanner(inputLine);

      scanner.expect('move ');
      scanner.expect(RegExp(r'\d+'));
      int nCrates = int.parse(scanner.lastMatch![0]!);

      scanner.expect(' from ');
      scanner.expect(RegExp(r'\d+'));
      int fromCrateStack = int.parse(scanner.lastMatch![0]!);

      scanner.expect(' to ');
      scanner.expect(RegExp(r'\d+'));
      int toCrateStack = int.parse(scanner.lastMatch![0]!);

      instructions.add(Tuple3(nCrates, fromCrateStack, toCrateStack));
    }

    return instructions;
  }

  List<ListQueue<String>> _getInitialStacksFromInput(List<String> inputLines) {
    // create empty list of crate stacks
    int nCrateStacks = (inputLines[0].length / 4).ceil();
    List<ListQueue<String>> crateStacks = List.generate(nCrateStacks, (_) => ListQueue<String>(), growable: false);

    // read initial crate stacks
    for (int i = 0; i < inputLines.length; i++) {
      String line = inputLines[i];

      if (!line.trim().startsWith('[')) {
        // we reached the end of the initial crate stack description
        return crateStacks; 
      }

      for (var j = 0; j < line.length; j += 4) {
        if (line[j] == '[') {
          crateStacks[j ~/ 4].addLast(line[j + 1]);
        }
      }
    }

    return crateStacks;
  }

}
