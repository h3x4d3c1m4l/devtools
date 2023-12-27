import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

typedef WorkflowRule = ({String? firstParam, int? secondParam, String? thirdParam, _RuleType type});
typedef Workflow = ({String name, List<WorkflowRule> rules});

class Day19Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 19;

  @override
  String getSolution(String input) {
    List<String> rawLineSets = input.split('\r\n\r\n'); // TODO: fix this on unix OS'es

    List<Workflow> workflows = rawLineSets[0].splitLines().map((rawWorkflow) {
      var split = rawWorkflow.split('{');
      return (
        name: split[0],
        rules: split[1].substring(0, split[1].length - 1).split(',').map((rawRule) {
          if (rawRule == 'A') {
            return (type: _RuleType.accept, firstParam: null, secondParam: null, thirdParam: null);
          } else if (rawRule == 'R') {
            return (type: _RuleType.reject, firstParam: null, secondParam: null, thirdParam: null);
          } else if (rawRule.contains('>')) {
            var rawRuleSplit = rawRule.split(':');
            var rawRuleSplit2 = rawRuleSplit[0].split('>');
            return (type: _RuleType.moreThan, firstParam: rawRuleSplit2[0], secondParam: int.parse(rawRuleSplit2[1]), thirdParam: rawRuleSplit[1]);
          } else if (rawRule.contains('<')) {
            var rawRuleSplit = rawRule.split(':');
            var rawRuleSplit2 = rawRuleSplit[0].split('<');
            return (type: _RuleType.lessThan, firstParam: rawRuleSplit2[0], secondParam: int.parse(rawRuleSplit2[1]), thirdParam: rawRuleSplit[1]);
          } else {
            return (type: _RuleType.toWorkflow, firstParam: rawRule, secondParam: null, thirdParam: null);
          }
        }).toList(),
      );
    }).toList();

    List<Map<String, int>> ratings = rawLineSets[1].splitLines().map((rawRatingLine) {
      return Map.fromEntries(rawRatingLine.substring(1, rawRatingLine.length - 1).split(',').map((rawRating) {
        var split = rawRating.split('=');
        return MapEntry(split[0], int.parse(split[1]));
      }));
    }).toList();

    // Part 1
    int part1 = ratings.fold(0, (previousValue, itemRatings) {
      return previousValue + (_checkIfPartAccepted(itemRatings, workflows) ? itemRatings.values.sum : 0);
    });

    // Part 2
    int part2 = 0;

    return 'Part 1: $part1\nPart 2: $part2';
  }

  bool _checkIfPartAccepted(Map<String, int> partRatings, List<Workflow> workflows, [String workflowName = 'in']) {
    Workflow workflow = workflows.firstWhere((workflow) => workflow.name == workflowName);
    for (WorkflowRule rule in workflow.rules) {
      switch (rule.type) {
        case _RuleType.moreThan:
          int rating = partRatings[rule.firstParam!]!;
          if (rating > rule.secondParam!) {
            return switch (rule.thirdParam) {
              'A' => true,
              'R' => false,
              _ => _checkIfPartAccepted(partRatings, workflows, rule.thirdParam!)
            };
          }
        case _RuleType.lessThan:
          int rating = partRatings[rule.firstParam!]!;
          if (rating < rule.secondParam!) {
            return switch (rule.thirdParam) {
              'A' => true,
              'R' => false,
              _ => _checkIfPartAccepted(partRatings, workflows, rule.thirdParam!)
            };
          }
        case _RuleType.accept:
          return true;
        case _RuleType.reject:
          return false;
        case _RuleType.toWorkflow:
          return _checkIfPartAccepted(partRatings, workflows, rule.firstParam!);
      }
    }
    throw Exception('Should not be reached');
  }

}

enum _RuleType {

  moreThan,
  lessThan,
  accept,
  reject,
  toWorkflow,

}
