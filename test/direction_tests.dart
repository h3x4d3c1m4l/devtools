import 'package:flutter_test/flutter_test.dart';
import 'package:h3x_devtools/solvers/helpers/_all_helpers.dart';

void main() {
  test('Direction canGoDirection works', () {
    Grid<String> grid = Grid.fromString('XXX\nXXX\nXXX', (value) => value);
    Coordinates centerCoordinates = Coordinates(1, 1, grid);

    for (Direction direction in Direction.values) {
      expect(centerCoordinates.canGoDirection(direction, 1), true);
    }

  for (Direction direction in Direction.values) {
      expect(centerCoordinates.canGoDirection(direction, 2), false);
    }
  });
}
