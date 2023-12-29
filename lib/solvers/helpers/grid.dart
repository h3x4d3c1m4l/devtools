import 'dart:collection';

import 'package:h3x_devtools/solvers/helpers/enums.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Grid<T> {

  late List<List<Cell<T>>> rows;
  late List<List<Cell<T>>> columns;

  int get width => columns.length;
  int get height => rows.length;

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

  bool get canGoWest => x > 0;
  bool get canGoEast => x < grid!.width - 1;
  bool get canGoNorth => y > 0;
  bool get canGoNorthWest => canGoNorth && canGoWest;
  bool get canGoNorthEast => canGoNorth && canGoEast;
  bool get canGoSouth => y < grid!.height - 1;
  bool get canGoSouthWest => canGoSouth && canGoWest;
  bool get canGoSouthEast => canGoSouth && canGoEast;

  Coordinates goNorth() => copyWith(y: y - 1);
  Coordinates goNorthWest() => copyWith(x: x - 1, y: y - 1);
  Coordinates goNorthEast() => copyWith(x: x + 1, y: y - 1);
  Coordinates goSouth() => copyWith(y: y + 1);
  Coordinates goSouthWest() => copyWith(x: x - 1, y: y + 1);
  Coordinates goSouthEast() => copyWith(x: x + 1, y: y + 1);
  Coordinates goWest() => copyWith(x: x - 1);
  Coordinates goEast() => copyWith(x: x + 1);

  Coordinates goToDirection(Direction direction) {
    return switch (direction) {
      Direction.north => goNorth(),
      Direction.northEast => goNorthEast(),
      Direction.east => goEast(),
      Direction.southEast => goSouthEast(),
      Direction.south => goSouth(),
      Direction.southWest => goSouthWest(),
      Direction.west => goWest(),
      Direction.northWest => goNorthWest(),
    };
  }

  Coordinates goToCDirection(CardinalDirection direction) {
    return switch (direction) {
      CardinalDirection.north => goNorth(),
      CardinalDirection.east => goEast(),
      CardinalDirection.south => goSouth(),
      CardinalDirection.west => goWest(),
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
