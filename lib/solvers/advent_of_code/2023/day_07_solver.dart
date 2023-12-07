import 'package:collection/collection.dart';
import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/extensions.dart';

typedef HandAndBid = ({int bid, List<String> hand});

class Day07Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 7;

  static const _cardsPerHand = 5;

  static const List<String> _cardRankPart1 = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'];
  static const List<String> _cardRankPart2 = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'];

  @override
  String getSolution(String input) {
    List<String> inputLines = input.splitLines().toList();
    List<HandAndBid> handsAndBids = inputLines.map((line) {
      var rawHandAndBid = line.split(' ');
      return (hand: rawHandAndBid[0].split(''), bid: int.parse(rawHandAndBid[1]));
    }).toList();

    // Part 1
    int part1 = handsAndBids.sorted((a, b) {
      // First compare hand type
      _HandType handTypeA = _getHandTypePart1(a.hand);
      _HandType handTypeB = _getHandTypePart1(b.hand);
      if (handTypeA != handTypeB) {
        return handTypeB.index.compareTo(handTypeA.index);
      }

      // Same hand types, look at individual cards
      for (int i = 0; i < _cardsPerHand; i++) {
        int rankA = _cardRankPart1.indexOf(a.hand[i]);
        int rankB = _cardRankPart1.indexOf(b.hand[i]);
        if (rankA != rankB) return rankB.compareTo(rankA);
      }

      // Hands are equal in value
      return 0;
    }).foldIndexed(0, (index, previous, element) => previous + (index + 1) * element.bid);

    // Part 2
    int part2 = handsAndBids.sorted((a, b) {
      // First compare hand type
      _HandType handTypeA = _getHandTypePart2(a.hand);
      _HandType handTypeB = _getHandTypePart2(b.hand);
      if (handTypeA != handTypeB) {
        return handTypeB.index.compareTo(handTypeA.index);
      }

      // Same hand types, look at individual cards
      for (int i = 0; i < _cardsPerHand; i++) {
        int rankA = _cardRankPart2.indexOf(a.hand[i]);
        int rankB = _cardRankPart2.indexOf(b.hand[i]);
        if (rankA != rankB) return rankB.compareTo(rankA);
      }

      // Hands are equal in value
      return 0;
    }).foldIndexed(0, (index, previous, element) => previous + (index + 1) * element.bid);

    return 'Part 1: $part1\nPart 2: $part2';
  }

  _HandType _getHandTypePart1(List<String> cards) {
    assert(cards.length == _cardsPerHand, 'A hands must have 5 cards');
    Map<String, List<String>> cardGroups = cards.groupListsBy((card) => card);

    if (cardGroups.length == 1) {
      return _HandType.fiveOfAKind;
    } else if (cardGroups.length == 2 && cardGroups.values.any((cardGroup) => cardGroup.length == 4)) {
      return _HandType.fourOfAKind;
    } else if (cardGroups.length == 2) {
      return _HandType.fullHouse;
    } else if (cardGroups.length == 3 && cardGroups.values.any((cardGroup) => cardGroup.length == 3)) {
      return _HandType.threeOfAKind;
    } else if (cardGroups.length == 3) {
      return _HandType.twoPair;
    } else if (cardGroups.length == 4) {
      return _HandType.onePair;
    } else {
      return _HandType.highCard;
    }
  }

  _HandType _getHandTypePart2(List<String> cards) {
    assert(cards.length == _cardsPerHand, 'A hands must have 5 cards');

    List<String> virtualCards = [...cards];
    while (virtualCards.any((card) => card == 'J')) {
      if (virtualCards.where((card) => card == 'J').length >= 4) {
        // Shortcut
        return _HandType.fiveOfAKind;
      }

      Map<String, List<String>> cardGroups = virtualCards.groupListsBy((card) => card);
      String mostOccuringCard = cardGroups.values.where((card) => card.first != 'J').orderByThenLast((element) => element.length).first;

      // Replace J by most occuring card to increase hand type
      virtualCards
        ..remove('J')
        ..add(mostOccuringCard);
    }
    
    return _getHandTypePart1(virtualCards);
  }

}

enum _HandType {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPair,
  onePair,
  highCard,
}
