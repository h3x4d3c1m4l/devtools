import 'dart:math';

(double, double) abcFormula(num a, num b, num c) {
  return (
    (-b + sqrt(pow(b, 2) - 4 * a * c) / 2 * a),
    (-b - sqrt(pow(b, 2) - 4 * a * c) / 2 * a),
  );
}
