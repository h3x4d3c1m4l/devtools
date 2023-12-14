import 'dart:convert';
import 'package:collection/collection.dart';

// ///////////////// //
// String extensions //
// ///////////////// //

extension StringExtension on String {

  bool get isDigit => length == 1 && codeUnits[0].isDigit;
  bool get isDigit1to9 => length == 1 && codeUnits[0].isDigit1to9;
  bool get isDot => length == 1 && codeUnits[0].isDot;

  Iterable<String> splitLines() => LineSplitter.split(this);
  List<String> toListOfLines() => splitLines().toList();
  String insert(String string, int position) => '${substring(0, position)}$string${substring(position)}';
  String repeat(int times, [String joinString = '']) => List.filled(times, this).join(joinString);
  List<String> toCharacterList() => split('');

}

extension StringIterableExtension on Iterable<String> {

  Iterable<int> get parsedAsInts => map(int.parse);
  Iterable<BigInt> get parsedAsBigInts => map(BigInt.parse);
  List<int> toIntList() => parsedAsInts.toList();
  List<BigInt> toBigIntList() => parsedAsBigInts.toList();

}

// ///////////////////// //
// Int/BigInt extensions //
// ///////////////////// //

extension IntExtension on int {

  bool get isDigit => this >= 48 && this <= 57;
  bool get isDigit1to9 => this >= 49 && this <= 58;
  bool get isDot => this == 46;
  int lcm(int other) => (this * other).abs() ~/ gcd(other);

}

extension BigIntExtension on BigInt {

  BigInt lcm(BigInt other) => (this * other).abs() ~/ gcd(other);

}

extension IntIterableExtension on Iterable<int> {

  int get gcd => fold(0, (previousValue, element) => previousValue.gcd(element));
  int get lcm => fold(1, (previousValue, element) => previousValue.lcm(element));
  Iterable<BigInt> get toBigInts => map(BigInt.from);

}

extension BigIntIterableExtension on Iterable<BigInt> {

  BigInt get product => fold(BigInt.one, (previousValue, element) => previousValue * element);
  BigInt get gcd => fold(BigInt.zero, (previousValue, element) => previousValue.gcd(element));
  BigInt get lcm => fold(BigInt.one, (previousValue, element) => previousValue.lcm(element));

}

// //////////////////////// //
// Misc iterable extensions //
// //////////////////////// //

extension NumIterableExtension on Iterable<num> {

  num get product => fold(1, (previousValue, element) => previousValue * element);

}

extension IterableExtension<T> on Iterable<T> {

  int gcdBy(int Function(T element) valueSelector) => map(valueSelector).gcd;

  TNum sumBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).sum as TNum;
  TNum minBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).min as TNum;
  TNum maxBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).max as TNum;
  TNum productBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).product as TNum;

  T orderByThenFirst<TOrderKey extends Comparable>(TOrderKey Function(T element) valueSelector) => reduce(
      (value, element) => Comparable.compare(valueSelector(element), valueSelector(value)) < 0 ? element : value);
  T orderByThenLast<TOrderKey extends Comparable>(TOrderKey Function(T element) valueSelector) => reduce(
      (value, element) => Comparable.compare(valueSelector(element), valueSelector(value)) > 0 ? element : value);

}
