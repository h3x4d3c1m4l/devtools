import 'dart:convert';

import 'package:collection/collection.dart';

extension StringExtension on String {

  bool get isDigit => length == 1 && codeUnits[0].isDigit;
  bool get isDigit1to9 => length == 1 && codeUnits[0].isDigit1to9;
  bool get isDot => length == 1 && codeUnits[0].isDot;

  Iterable<String> splitLines() => LineSplitter.split(this);

}

extension IntExtension on int {

  bool get isDigit => this >= 48 && this <= 57;
  bool get isDigit1to9 => this >= 49 && this <= 58;
  bool get isDot => this == 46;

}

extension IterableExtension<T> on Iterable<T> {

  TNum sumBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).sum as TNum;
  TNum minBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).min as TNum;
  TNum maxBy<TNum extends num>(TNum Function(T element) valueSelector) => map(valueSelector).max as TNum;
  T orderByThenFirst<TOrderKey extends Comparable>(TOrderKey Function(T element) valueSelector) => reduce(
      (value, element) => Comparable.compare(valueSelector(element), valueSelector(value)) < 0 ? element : value);
  T orderByThenLast<TOrderKey extends Comparable>(TOrderKey Function(T element) valueSelector) => reduce(
      (value, element) => Comparable.compare(valueSelector(element), valueSelector(value)) > 0 ? element : value);

}
