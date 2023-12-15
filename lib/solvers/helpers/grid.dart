import 'package:equatable/equatable.dart';

class Grid<T> extends Equatable {

  final int width, height;
  final List<T> _grid;

  Grid.filled({required this.width, required this.height, required T initialValue})
      : _grid = List.filled(width * height, initialValue);

  Grid.generated({required this.width, required this.height, required T Function(int x, int y) getValue})
      : _grid = List.generate(width * height, (index) {
          final (:int x, :int y) = _getCoordinates(width: width, arrayIndex: index);
          return getValue(x, y);
        });

  const Grid.fromList({required this.width, required this.height, required List<T> cells})
      : _grid = cells;

  // ////////////// //
  // Static helpers //
  // ////////////// //

  static int _getBackingArrayIndex({required int width, required int x, required int y}) {
    return width * y + x;
  }

  static ({int x, int y}) _getCoordinates({required int width, required int arrayIndex}) {
    return (
      x: arrayIndex % width,
      y: arrayIndex ~/ width,
    );
  }

  // //////////////// //
  // Get/Set by index //
  // //////////////// //

  T getValue({required int x, required int y}) {
    int arrayIndex = _getBackingArrayIndex(width: width, x: x, y: y);
    return _grid[arrayIndex];
  }

  void setValue({required int x, required int y, required T value}) {
    int arrayIndex = _getBackingArrayIndex(width: width, x: x, y: y);
    _grid[arrayIndex] = value;
  }
  
  T replaceValue({required int x, required int y, required T newValue}) {
    int arrayIndex = _getBackingArrayIndex(width: width, x: x, y: y);
    T oldValue = _grid[arrayIndex];
    _grid[arrayIndex] = newValue;
    return oldValue;
  }

  // //// //
  // Find //
  // //// //

  ({int x, int y}) getCoordinatesOfFirstWhere(bool Function(T) test) {
    int index = _grid.indexWhere(test);
    return _getCoordinates(width: width, arrayIndex: index);
  }

  ({int x, int y}) getCoordinatesOf(T item) {
    int index = _grid.indexOf(item);
    return _getCoordinates(width: width, arrayIndex: index);
  }

  // //// //
  // Misc //
  // //// //

  Grid<T> clone() => Grid<T>.fromList(width: width, height: height, cells: [..._grid]);

  @override
  List<Object> get props => [width, height, _grid];

  @override
  String toString() {
    StringBuffer sb = StringBuffer('Grid<$T> ($width x $height)')
      ..writeln();

    for (int y = 0; y < height; y++) {
      String gridLine = _grid.skip(y * width).take(width).join();
      sb.writeln(gridLine);
    }

    return sb.toString();
  }

}

enum Directions {

  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest,

}
