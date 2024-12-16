import 'dart:collection';

import 'package:h3x_devtools/solvers/helpers/enums.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Grid<T> {

  late List<List<Cell<T>>> rows;
  late List<List<Cell<T>>> columns;

  int get width => columns.length;
  int get height => rows.length;

  Cell<T> operator [](Coordinates coordinates) => rows[coordinates.y][coordinates.x];

  Grid.filled({required int width, required int height, required T initialValue}) {
    rows = Iterable.generate(
      height,
      (rIndex) => Iterable.generate(width, (cIndex) => Cell(initialValue)).toUnmodifiableList(),
    ).toUnmodifiableList();

    columns = Iterable.generate(width)
        .map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList())
        .toUnmodifiableList();
  }

  Grid.generated({required int width, required int height, required T Function(int x, int y) getValue}) {
    rows = Iterable.generate(
      height,
      (rIndex) => Iterable.generate(width, (cIndex) => Cell(getValue(cIndex, rIndex))).toUnmodifiableList(),
    ).toUnmodifiableList();

    columns = Iterable.generate(width)
        .map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList())
        .toUnmodifiableList();
  }

  Grid.fromString(String grid, T Function (String value) valueConverter) {
    List<String> lines = grid.splitLines().toList();
    int calculatedWidth = lines.first.length, calculatedHeight = lines.length;

    rows = Iterable.generate(
      calculatedHeight,
      (rIndex) => Iterable.generate(calculatedWidth, (cIndex) => Cell<T>(valueConverter(lines[rIndex][cIndex]))).toUnmodifiableList(),
    ).toUnmodifiableList();

    columns = Iterable.generate(calculatedWidth)
        .map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList())
        .toUnmodifiableList();
  }

  // //////////////// //
  // Get/Set by index //
  // //////////////// //

  T getValue(Coordinates coordinates) => columns[coordinates.x][coordinates.y].obj;

  void setValue(Coordinates coordinates, T value) => columns[coordinates.x][coordinates.y].obj = value;

  T replaceValue(Coordinates coordinates, T newValue) {
    T oldValue = columns[coordinates.x][coordinates.y].obj;
    columns[coordinates.x][coordinates.y].obj = newValue;
    return oldValue;
  }

  List<T> getValues(Coordinates start, Direction direction, int count) {
    return count == 0
        ? const []
        : [
            getValue(start),
            ...getValues(start.goToDirection(direction), direction, count - 1),
          ];
  }

  // //// //
  // Find //
  // //// //

  Coordinates? getCoordinatesOfFirstWhere(bool Function(T) test) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (test(rows[y][x].obj)) return Coordinates(x, y, this);
      }
    }
    return null;
  }

  Coordinates? getCoordinatesOf(T item) {
     for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (rows[y][x].obj == item) return Coordinates(x, y, this);
      }
    }
    return null;
  }

  Iterable<Coordinates> coordinatesOf(T item) sync* {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (rows[y][x].obj == item) yield Coordinates(x, y, this);
      }
    }
  }

  Iterable<Coordinates> coordinatesWhere(bool Function(T) test) sync* {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (test(rows[y][x].obj)) yield Coordinates(x, y, this);
      }
    }
  }

  // //// //
  // Flip //
  // //// //

  void flipVertically() {
    rows = rows.reversed.toUnmodifiableList();
    columns = columns.map((column) => column.reversed.toUnmodifiableList()).toUnmodifiableList();
  }

  void flipHorizontally() {
    columns = columns.reversed.toUnmodifiableList();
    rows = rows.map((row) => row.reversed.toUnmodifiableList()).toUnmodifiableList();
  }

  void transpose() {
    var rows = this.rows;
    this.rows = columns;
    columns = rows;
  }

  // //// //
  // Fill //
  // //// //

  // Algorithm: https://en.wikipedia.org/wiki/Flood_fill#Moving_the_recursion_into_a_data_structure
  void floodFill4Way(Coordinates start, T replace, T replaceWith) {
    Queue<Coordinates> q = Queue()..add(start);
    while (q.isNotEmpty) {
      Coordinates n = q.removeFirst();
      if (getValue(n) != replace) continue;

      setValue(n, replaceWith);
      if (n.canGoWest) q.addLast(n.goWest());
      if (n.canGoEast) q.addLast(n.goEast());
      if (n.canGoNorth) q.addLast(n.goNorth());
      if (n.canGoSouth) q.addLast(n.goSouth());
    }
  }

  // Algorithm: https://en.wikipedia.org/wiki/Flood_fill#Span_filling
  // For some reason it skips some parts. Also in its current form,
  // it is not faster than floodFill4Way() at all.
  void spanFillOptimizedNotWorking(Coordinates start, T replace, T replaceWith) {
    if (getValue(start) != replace) return;

    int x = start.x, y = start.y;

    Queue<(int, int, int, int)> s = Queue()
      ..add((x, x, y, 1))
      ..add((x, x, y - 1, -1));

    while (s.isNotEmpty) {
      var (x1, x2, y, dy) = s.removeFirst();
      x = x1;
      if (getValue(Coordinates(x, y)) == replace) {
        while (getValue(Coordinates(x - 1, y)) == replace) {
          setValue(Coordinates(x - 1, y), replaceWith);
          x = x - 1;
        }
        if (x < x1) {
          s.addLast((x1, x1 - 1, y - dy, -dy));
        }
      }
      while (x1 <= x2) {
        while (getValue(Coordinates(x1, y)) == replace) {
          setValue(Coordinates(x1, y), replaceWith);
          x1 = x1 + 1;
        }
        if (x1 > x) {
          s.addLast((x, x1 - 1, y + dy, dy));
        }
        if (x1 - 1 > x2) {
          s.addLast((x2 + 1, x1 - 1, y - dy, -dy));
        }
        x1 = x1 + 1;
        while (x1 < x2 && getValue(Coordinates(x1, y)) != replace) {
          x1 = x1 + 1;
        }
        x = x1;
      }
    }
  }

  // //// //
  // Misc //
  // //// //

  @override
  String toString() {
    return 'Grid<$T> ($width x $height)'; // TODO scanout of values
  }

  String toStringDense() {
    return rows.fold("Grid<$T> ($width x $height)\n", (oldValue, item) {
      return '$oldValue\n${item.map((item) {
        // Shorten string representation to 1 char
        return item.toString().padLeft(1).substring(0, 1);
      }).join()}';
    });
  }

}

class Cell<T> {

  T obj;

  Cell(this.obj);

  @override
  String toString() => obj.toString();

}

class Coordinates {

  final int x, y;
  final Grid? grid;

  const Coordinates(this.x, this.y, [this.grid]);

  bool get canGoNorth => canGoNorthFor(1);
  bool get canGoNorthEast => canGoNorthEastFor(1);
  bool get canGoEast => canGoEastFor(1);
  bool get canGoSouthEast => canGoSouthEastFor(1);
  bool get canGoSouth => canGoSouthFor(1);
  bool get canGoSouthWest => canGoSouthWestFor(1);
  bool get canGoWest => canGoWestFor(1);
  bool get canGoNorthWest => canGoNorthWestFor(1);

  bool canGoNorthFor(int steps) => y - steps >= 0;
  bool canGoNorthEastFor(int steps) => canGoNorthFor(steps) && canGoEastFor(steps);
  bool canGoEastFor(int steps) => x + steps < grid!.width;
  bool canGoSouthEastFor(int steps) => canGoSouthFor(steps) && canGoEastFor(steps);
  bool canGoSouthFor(int steps) => y + steps < grid!.height;
  bool canGoSouthWestFor(int steps) => canGoSouthFor(steps) && canGoWestFor(steps);
  bool canGoWestFor(int steps) => x - steps >= 0;
  bool canGoNorthWestFor(int steps) => canGoNorthFor(steps) && canGoWestFor(steps);

  Coordinates goNorth([int steps = 1]) => copyWith(y: y - steps);
  Coordinates goNorthEast([int steps = 1]) => copyWith(x: x + steps, y: y - steps);
  Coordinates goEast([int steps = 1]) => copyWith(x: x + steps);
  Coordinates goSouthEast([int steps = 1]) => copyWith(x: x + steps, y: y + steps);
  Coordinates goSouth([int steps = 1]) => copyWith(y: y + steps);
  Coordinates goSouthWest([int steps = 1]) => copyWith(x: x - steps, y: y + steps);
  Coordinates goWest([int steps = 1]) => copyWith(x: x - steps);
  Coordinates goNorthWest([int steps = 1]) => copyWith(x: x - steps, y: y - steps);

  bool canGoDirection(Direction direction, [int steps = 1]) {
    return switch (direction) {
      Direction.north => canGoNorthFor(steps),
      Direction.northEast => canGoNorthEastFor(steps),
      Direction.east => canGoEastFor(steps),
      Direction.southEast => canGoSouthEastFor(steps),
      Direction.south => canGoSouthFor(steps),
      Direction.southWest => canGoSouthWestFor(steps),
      Direction.west => canGoWestFor(steps),
      Direction.northWest => canGoNorthWestFor(steps),
    };
  }

  Coordinates goToDirection(Direction direction, [int steps = 1]) {
    return switch (direction) {
      Direction.north => goNorth(steps),
      Direction.northEast => goNorthEast(steps),
      Direction.east => goEast(steps),
      Direction.southEast => goSouthEast(steps),
      Direction.south => goSouth(steps),
      Direction.southWest => goSouthWest(steps),
      Direction.west => goWest(steps),
      Direction.northWest => goNorthWest(steps),
    };
  }

  bool canGoCDirection(CardinalDirection direction, [int steps = 1]) {
    return switch (direction) {
      CardinalDirection.north => canGoNorthFor(steps),
      CardinalDirection.east => canGoEastFor(steps),
      CardinalDirection.south => canGoSouthFor(steps),
      CardinalDirection.west => canGoWestFor(steps),
    };
  }

  Coordinates goToCDirection(CardinalDirection direction, [int steps = 1]) {
    return switch (direction) {
      CardinalDirection.north => goNorth(steps),
      CardinalDirection.east => goEast(steps),
      CardinalDirection.south => goSouth(steps),
      CardinalDirection.west => goWest(steps),
    };
  }

  @override
  bool operator ==(Object other) => other is Coordinates && other.runtimeType == runtimeType && other.x == x && other.y == y && other.grid == grid;

  @override
  int get hashCode => Object.hash(x, y, grid);

  Coordinates copyWith({int? x, int? y}) {
    return Coordinates(x ?? this.x, y ?? this.y, grid);
  }

}
