import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

typedef _BinaryTreeNode = (String value, {String left, String right});

class Day08Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 8;

  @override
  String getSolution(String input) {
    List<String> inputLines = input.splitLines().toList();

    String route = inputLines[0];
    List<_BinaryTreeNode> nodes = inputLines.skip(2).map((rawNode) {
      var split = rawNode.split(' = ');
      var split2 = split[1].split(', ');
      return (split[0], left: split2[0].substring(1), right: split2[1].substring(0, split2[1].length - 1));
    }).toList();

    // Part 1
    var part1Steps = 0;

    // Traverse nodes till we found the ZZZ node
    _BinaryTreeNode currentNode = nodes.firstWhere((node) => node.$1 == 'AAA');
    for (; currentNode.$1 != 'ZZZ'; part1Steps++) {
      String currentRouteInstruction = route[part1Steps % route.length];
      if (currentRouteInstruction == 'L') {
        currentNode = nodes.firstWhere((node) => node.$1 == currentNode.left);
      } else if (currentRouteInstruction == 'R') {
        currentNode = nodes.firstWhere((node) => node.$1 == currentNode.right);
      } else {
        throw Exception('Unknown instruction \'$currentRouteInstruction\' found');
      }
    }

    // Part 2

    // Determine start nodes
    List<_BinaryTreeNode> startNodes = nodes.where((node) => node.$1.endsWith('A')).toList();
    List<int> nodeTraversionCounters = List.filled(startNodes.length, 0);

    // Traverse from all start nodes until we find the corresponding end nodes
    for (int i = 0; i < startNodes.length; i++) {
      List<_BinaryTreeNode> seenNodes = [];

      _BinaryTreeNode currentNode = startNodes[i];
      while (!currentNode.$1.endsWith('Z')) {
        String currentRouteInstruction = route[seenNodes.length % route.length];
        seenNodes.add(currentNode);

        // Advance node
        if (currentRouteInstruction == 'L') {
          currentNode = nodes.firstWhere((node) => node.$1 == currentNode.left);
        } else if (currentRouteInstruction == 'R') {
          currentNode = nodes.firstWhere((node) => node.$1 == currentNode.right);
        } else {
          throw Exception('Unknown instruction \'$currentRouteInstruction\' found');
        }
      }

      nodeTraversionCounters[i] = seenNodes.length;
    }

    // Find the lowest traversal count for which all paths have reached a Z-node
    // This uses LCM (Least common multiple)
    var part2 = nodeTraversionCounters.lcm;

    return 'Part 1: $part1Steps\nPart 2: $part2';
  }

}
