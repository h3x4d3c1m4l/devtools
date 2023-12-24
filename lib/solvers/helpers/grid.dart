import 'package:h3x_devtools/solvers/helpers/extensions.dart';

class Grid<T> {

  late final List<List<Cell<T>>> rows;
  late final List<List<Cell<T>>> columns;

  int get width => columns.length;
  int get height => rows.length;

  Grid.filled({required int width, required int height, required T initialValue}) {
    rows = List.generate(
      height,
      (rIndex) => List.generate(width, (cIndex) => Cell(initialValue)).toUnmodifiableList(),
    ).toUnmodifiableList();
    columns = Iterable.generate(width).map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList()).toUnmodifiableList();
  }

  Grid.generated({required int width, required int height, required T Function(int x, int y) getValue}) {
    rows = List.generate(
      height,
      (rIndex) => List.generate(width, (cIndex) => Cell(getValue(cIndex, rIndex))).toUnmodifiableList(),
    ).toUnmodifiableList();
    columns = Iterable.generate(width).map((cIndex) => rows.map((row) => row[cIndex]).toUnmodifiableList()).toUnmodifiableList();
  }

  // //////////////// //
  // Get/Set by index //
  // //////////////// //

  T getValue({required int x, required int y}) => columns[x][y].obj;

  void setValue({required int x, required int y, required T value}) => columns[x][y].obj = value;
  
  T replaceValue({required int x, required int y, required T newValue}) {
    T oldValue = columns[x][y].obj;
    columns[x][y].obj = newValue;
    return oldValue;
  }

  // //// //
  // Find //
  // //// //

  ({int x, int y})? getCoordinatesOfFirstWhere(bool Function(T) test) {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (test(rows[y][x].obj)) return (x: x, y: y);
      } 
    }
    return null;
  }

  ({int x, int y})? getCoordinatesOf(T item) {
     for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        if (rows[y][x].obj == item) return (x: x, y: y);
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
