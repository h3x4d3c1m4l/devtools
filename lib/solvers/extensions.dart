extension StringExtension on String {

  bool get isDigit => length == 1 && codeUnits[0].isDigit;
  bool get isDigit1to9 => length == 1 && codeUnits[0].isDigit1to9;
  bool get isDot => length == 1 && codeUnits[0].isDot;

}

extension IntExtension on int {

  bool get isDigit => this >= 48 && this <= 57;
  bool get isDigit1to9 => this >= 49 && this <= 58;
  bool get isDot => this == 46;

}
