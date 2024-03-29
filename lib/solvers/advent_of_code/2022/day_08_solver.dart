import 'dart:math';

import 'package:darq/darq.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day08Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 8;
  
  @override
  String getSolution(String input) {
    List<String> mapLines = input.splitLines().toList(growable: false);
    int mapWidth = mapLines[0].length;
    int mapHeight = mapLines.length;
    
    // part 1
    int visibleFromOutside = mapWidth * 2 + (mapHeight - 2) * 2;
    for (int y = 1; y < (mapHeight - 1); y++) {
      List<int> rowCodeUnits = mapLines[y].codeUnits;
      for (int x = 1; x < (mapWidth - 1); x++) {
        List<int> columnCodeUnits = mapLines.map((row) => row[x]).join().codeUnits;
        int currentCodeUnit = rowCodeUnits[x];

        bool visibleFromLeft = rowCodeUnits.sublist(0, x).all((codeUnit) => codeUnit < currentCodeUnit);
        bool visibleFromRight = rowCodeUnits.sublist(x + 1, mapWidth).all((codeUnit) => codeUnit < currentCodeUnit);
        bool visibleFromTop = columnCodeUnits.sublist(0, y).all((codeUnit) => codeUnit < currentCodeUnit);
        bool visibleFromBottom = columnCodeUnits.sublist(y + 1, mapHeight).all((codeUnit) => codeUnit < currentCodeUnit);

        if (visibleFromLeft || visibleFromRight || visibleFromTop || visibleFromBottom) {
          visibleFromOutside++;
        }
      }
    }

    // part 2
    int maximumScenicScore = 0;
    for (int y = 0; y < mapHeight; y++) {
      List<int> rowCodeUnits = mapLines[y].codeUnits;
      for (int x = 0; x < mapWidth; x++) {
        List<int> columnCodeUnits = mapLines.map((row) => row[x]).join().codeUnits;
        int currentCodeUnit = rowCodeUnits[x];

        int treesVisibleLeft = treesVisibleNext(currentCodeUnit, rowCodeUnits.sublist(0, x).reversed);
        int treesVisibleRight = treesVisibleNext(currentCodeUnit, rowCodeUnits.sublist(x + 1, mapWidth));
        int treesVisibleTop = treesVisibleNext(currentCodeUnit, columnCodeUnits.sublist(0, y).reversed);
        int treesVisibleBottom = treesVisibleNext(currentCodeUnit, columnCodeUnits.sublist(y + 1, mapHeight));

        maximumScenicScore = max(maximumScenicScore, treesVisibleLeft * treesVisibleRight * treesVisibleTop * treesVisibleBottom);
      }
    }

    return 'Visible from outside: $visibleFromOutside\nMaximum scenic score: $maximumScenicScore';
  }

  int treesVisibleNext(int treeCodeUnit, Iterable<int> treeCodeUnitsNext) {
    int x = 0;

    for (int treeCodeUnitNext in treeCodeUnitsNext) {
      x++;

      if (treeCodeUnitNext >= treeCodeUnit) {
        return x;
      }
    }

    return x;
  }

}
