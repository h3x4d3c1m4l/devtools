import 'package:h3x_devtools/solvers/helpers/extensions.dart';

typedef Coordinates = ({int x, int y});

class Grid<T> {

  final int width, height;
  final List<T> _grid;

  Grid.filled({required this.width, required this.height, required T initialValue})
      : _grid = List.filled(width * height, initialValue);

  Grid.generated({required this.width, required this.height, required T Function(int x, int y) getValue})
      : _grid = List.generate(width * height, (index) {
          final (:int x, :int y) = _getCoordinates(width: width, arrayIndex: index);
          return getValue(x, y);
        });

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

  // ///// //
  // ///// //
  // ///// //

  int getH(Coordinates start, Coordinates end) {
    return (start.x - end.x).abs() + (start.y - end.y).abs();
  }

  List<Coordinates> aStar({required Coordinates start, required Coordinates end, required int Function (Coordinates neighbor, List<Coordinates> path) getTentativeGScore}) {
    // Use a collection that doesn't allow multiple of the same value
    // or change the `openSet.add(neighbor);` line
    Set<Coordinates> openSet = {start}; // TODO: Use PriorityQueue from collection
    Map<Coordinates, Coordinates> cameFrom = {};

    Map<Coordinates, int> gScore = {(x: start.x, y: start.y): 0};
    Map<Coordinates, int> fScore = {start: getH(start, end)};

    while (openSet.isNotEmpty) {
      var current = fScore.entries.orderByThenFirst((element) => getH(element.key, end)).key; // TODO: can get this from fScore I guess?
      if (current == end) return reconstructPath(cameFrom, current);

      openSet.remove(current);

      List<Coordinates> neighbors = [
        if (current.x > 0)
          (x: current.x - 1, y: current.y),
        if (current.x < width - 1)
          (x: current.x + 1, y: current.y),
        if (current.y > 0)
          (x: current.x, y: current.y - 1),
        if (current.y < height - 1)
          (x: current.x, y: current.y + 1),
      ];
      for (Coordinates neighbor in neighbors) {
        int tentativeGScore = gScore[current]! + getTentativeGScore(neighbor, reconstructPath(cameFrom, current));
        int? neighborGScore = gScore[neighbor];
        if (neighborGScore == null || tentativeGScore < neighborGScore) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = tentativeGScore + getH(neighbor, end);
          openSet.add(neighbor);
        }
      }
    }

    throw Exception('Goal not reachable');
  }

  List<Coordinates> reconstructPath(Map<Coordinates, Coordinates> cameFrom, Coordinates current) {
    List<Coordinates> totalPath = [current];
    for (var current in cameFrom.keys) {
        var cur2 = cameFrom[current]!;
        if (!totalPath.contains(cur2)) totalPath.insert(0, cur2); // HACK?
    }
    return [...totalPath.reversed.skip(1), totalPath.last];
  }

  // //// //
  // Misc //
  // //// //

  @override
  String toString() {
    return 'Grid<$T> ($width x $height)'; // TODO scanout of values
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
