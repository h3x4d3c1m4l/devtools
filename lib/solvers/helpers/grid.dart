import 'package:h3x_devtools/solvers/helpers/enums.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Grid<T> {

  late final List<List<Cell<T>>> rows;
  late final List<List<Cell<T>>> columns;

  int get width => columns.length;
  int get height => rows.length;

  Grid.filled({required int width, required int height, required T initialValue}) {
    rows = Iterable.generate(
      height,
      (rIndex) => Iterable.generate(width, (cIndex) => Cell(initialValue)).toUnmodifiableList(),
    ).toUnmodifiableList();
    columns = Iterable.generate(width).map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList()).toUnmodifiableList();
  }

  Grid.generated({required int width, required int height, required T Function(int x, int y) getValue}) {
    rows = Iterable.generate(
      height,
      (rIndex) => Iterable.generate(width, (cIndex) => Cell(getValue(cIndex, rIndex))).toUnmodifiableList(),
    ).toUnmodifiableList();
    columns = Iterable.generate(width).map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList()).toUnmodifiableList();
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
  // Misc //
  // //// //

  @override
  String toString() {
    return 'Grid<$T> ($width x $height)'; // TODO scanout of values
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
