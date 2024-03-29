import 'package:h3x_devtools/solvers/advent_of_code/2022/aoc_2022_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Day03Solver extends AdventOfCode2022Solver {

  @override
  final int dayNumber = 3;
  
  @override
  String getSolution(String input) {
    List<String> rawRucksacks = input.splitLines().toList();

    // part 1
    int totalCompartmentCommonItemPriorities = 0;
    for (String rawRucksack in rawRucksacks) {
      List<int> rucksackContentCodeUnits = rawRucksack.codeUnits;

      // find the item that appears in both compartments
      int halfOfList = rucksackContentCodeUnits.length ~/ 2;
      List<int> compartment1CodeUnits = rucksackContentCodeUnits.sublist(0, halfOfList);
      List<int> compartment2CodeUnits = rucksackContentCodeUnits.sublist(halfOfList);
      int commonCodeUnit = compartment1CodeUnits.firstWhere((c1CodeUnit) => compartment2CodeUnits.contains(c1CodeUnit));
      
      totalCompartmentCommonItemPriorities += _getRucksackItemPriority(commonCodeUnit);
    }

    // part 2
    int totalBadgePriorities = 0;
    for (int i = 0; i < rawRucksacks.length; i += 3) {
      List<int> rucksack1CodeUnits = rawRucksacks[i].codeUnits;
      List<int> rucksack2CodeUnits = rawRucksacks[i + 1].codeUnits;
      List<int> rucksack3CodeUnits = rawRucksacks[i + 2].codeUnits;

      // find the item that appears in all rucksacks
      int commonCodeUnit = rucksack1CodeUnits.firstWhere(
        (c1CodeUnit) => rucksack2CodeUnits.contains(c1CodeUnit) && rucksack3CodeUnits.contains(c1CodeUnit),
      );

      totalBadgePriorities += _getRucksackItemPriority(commonCodeUnit);
    }

    return 'Compartment common item priorities: $totalCompartmentCommonItemPriorities\nBadge priorities: $totalBadgePriorities';
  }

  int _getRucksackItemPriority(int rucksackItemCodeUnit) {
    final codeUnitLowercaseA = 'a'.codeUnitAt(0);
    final codeUnitUppercaseA = 'A'.codeUnitAt(0);

    if (rucksackItemCodeUnit >= codeUnitLowercaseA) {
      return rucksackItemCodeUnit - codeUnitLowercaseA + 1;
    } else {
      return rucksackItemCodeUnit - codeUnitUppercaseA + 27;
    }
  }

}
