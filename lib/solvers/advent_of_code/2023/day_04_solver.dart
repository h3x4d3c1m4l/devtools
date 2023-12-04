import 'dart:math';

import 'package:collection/collection.dart';
import 'package:darq/darq.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

typedef CardInput = ({List<int> myNumbers, List<int> winningNumbers});

class Day04Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 4;

  @override
  String getSolution(String input) {
    // Parse input
    List<CardInput> cards = input
        .split('\n')
        .where((engineSchematicLine) => engineSchematicLine.isNotEmpty)
        .map(
          (x) => (
            winningNumbers: List.generate(10, (index) => int.parse(x.substring(10 + 3 * index, 10 + 3 * index + 2).trimLeft())),
            myNumbers: List.generate(25, (index) => int.parse(x.substring(42 + 3 * index, 42 + 3 * index + 2).trimLeft()))
            // For sample data
            // winningNumbers: List.generate(5, (index) => int.parse(x.substring(8 + 3 * index, 8 + 3 * index + 2).trimLeft())),
            // myNumbers: List.generate(8, (index) => int.parse(x.substring(25 + 3 * index, 25 + 3 * index + 2).trimLeft()))
          ),
        )
        .toList();

    // Part 1
    int totalPointsWon = cards.fold(0, (previousValue, element) {
      int winningNumberCount = element.myNumbers.intersect(element.winningNumbers).count();
      return previousValue + switch (winningNumberCount) {
        1 => 1,
        >= 2 => pow(2, winningNumberCount - 1).round(),
        _ => 0,
      };
    });

    // Part 2
    Map<int, int> cardDuplications = {};
    for (int i = 0; i < cards.length; i++) {
      CardInput card = cards[i];
      int winningNumberCount = card.myNumbers.intersect(card.winningNumbers).count();

      // Keep into account that the card may have copies
      int sameCards = cardDuplications[i] ?? 0;

      int copyCardStart = i + 1, copyCardEnd = i + 1 + winningNumberCount;
      for (int j = copyCardStart; j < copyCardEnd; j++) {
        cardDuplications[j] = (cardDuplications[j] ?? 0) + 1 + sameCards;
      }
    }
    int totalCardsWon = cards.length + cardDuplications.values.sum;

    return 'Total points won: $totalPointsWon\nTotal cards won: $totalCardsWon';
  }

}
