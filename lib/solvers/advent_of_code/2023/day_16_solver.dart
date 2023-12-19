import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';

typedef _RayState = ({int x, int y, CardinalDirection direction});

class Day16Solver extends AdventOfCode2023Solver {

  @override
  final int dayNumber = 16;

  @override
  String getSolution(String input) {
    List<String> rawGridLines = input.splitLines().toList();
    Grid<_Tile> grid = Grid.generated(width: rawGridLines.first.length, height: rawGridLines.length, getValue: (x, y) {
      return _Tile.parseFromCharacter(rawGridLines[y][x]);
    });

    // Part 1
    int part1 = _getEnergizedTileCount(grid, 0, 0, CardinalDirection.east);

    // Part 2
    int part2 = 0;
    for (int x = 0; x < grid.width; x++) {
      part2 = max(part2, _getEnergizedTileCount(grid, x, 0, CardinalDirection.south));
      part2 = max(part2, _getEnergizedTileCount(grid, x, grid.height - 1, CardinalDirection.north));
    }
    for (int y = 1; y < grid.height - 1; y++) {
      part2 = max(part2, _getEnergizedTileCount(grid, 0, y, CardinalDirection.east));
      part2 = max(part2, _getEnergizedTileCount(grid, grid.width - 1, y, CardinalDirection.west));
    }

    return 'Part 1: $part1\nPart 2: $part2';
  }

  int _getEnergizedTileCount(Grid<_Tile> grid, int xStart, int yStart, CardinalDirection startDirection) {
    List<_RayState> currentBeams = [(x: xStart, y: yStart, direction: startDirection)];
    Set<({int x, int y})> energizedTiles = {};
    Set<_RayState> followedUpRayStates = {};

    while (currentBeams.isNotEmpty) {
      List<_RayState> beamsToAdd = [];
      for (_RayState beam in currentBeams) {
        energizedTiles.add((x: beam.x, y: beam.y));

        bool canGoNorth = beam.y > 0, canGoSouth = beam.y < grid.height - 1;
        bool canGoEast = beam.x < grid.width - 1, canGoWest = beam.x > 0;

        switch (grid.getValue(x: beam.x, y: beam.y)) {
          // Handle '|' and '.'
          case _Tile.vSplitter when beam.direction == CardinalDirection.north:
          case _Tile.empty when beam.direction == CardinalDirection.north:
            if (canGoNorth) beamsToAdd.add((x: beam.x, y: beam.y - 1, direction: CardinalDirection.north));
          case _Tile.vSplitter when beam.direction == CardinalDirection.south:
          case _Tile.empty when beam.direction == CardinalDirection.south:
            if (canGoSouth) beamsToAdd.add((x: beam.x, y: beam.y + 1, direction: CardinalDirection.south));
          case _Tile.vSplitter when beam.direction == CardinalDirection.east:
          case _Tile.vSplitter when beam.direction == CardinalDirection.west:
            if (canGoNorth) beamsToAdd.add((x: beam.x, y: beam.y - 1, direction: CardinalDirection.north));
            if (canGoSouth) beamsToAdd.add((x: beam.x, y: beam.y + 1, direction: CardinalDirection.south));

          // Handle '-' and '.'
          case _Tile.hSplitter when beam.direction == CardinalDirection.east:
          case _Tile.empty when beam.direction == CardinalDirection.east:
            if (canGoEast) beamsToAdd.add((x: beam.x + 1, y: beam.y, direction: CardinalDirection.east));
          case _Tile.hSplitter when beam.direction == CardinalDirection.west:
          case _Tile.empty when beam.direction == CardinalDirection.west:
            if (canGoWest) beamsToAdd.add((x: beam.x - 1, y: beam.y, direction: CardinalDirection.west));
          case _Tile.hSplitter when beam.direction == CardinalDirection.north:
          case _Tile.hSplitter when beam.direction == CardinalDirection.south:
            if (canGoWest) beamsToAdd.add((x: beam.x - 1, y: beam.y, direction: CardinalDirection.west));
            if (canGoEast) beamsToAdd.add((x: beam.x + 1, y: beam.y, direction: CardinalDirection.east));

          // Handle '\' and '/'
          case _Tile.bMirror when beam.direction == CardinalDirection.north:
          case _Tile.fMirror when beam.direction == CardinalDirection.south:
            if (canGoWest) beamsToAdd.add((x: beam.x - 1, y: beam.y, direction: CardinalDirection.west));
          case _Tile.bMirror when beam.direction == CardinalDirection.east:
          case _Tile.fMirror when beam.direction == CardinalDirection.west:
            if (canGoSouth) beamsToAdd.add((x: beam.x, y: beam.y + 1, direction: CardinalDirection.south));
          case _Tile.bMirror when beam.direction == CardinalDirection.south:
          case _Tile.fMirror when beam.direction == CardinalDirection.north:
            if (canGoEast) beamsToAdd.add((x: beam.x + 1, y: beam.y, direction: CardinalDirection.east));
          case _Tile.bMirror when beam.direction == CardinalDirection.west:
          case _Tile.fMirror when beam.direction == CardinalDirection.east:
            if (canGoNorth) beamsToAdd.add((x: beam.x, y: beam.y - 1, direction: CardinalDirection.north));

          default:
            throw Exception("This is impossible");
        }

        // Keep track of paths we have already followed because otherwise we will be in an endless loop 
        followedUpRayStates.add(beam);
      }

      // Run replacements and adds
      currentBeams
        ..addAll(beamsToAdd)
        ..removeWhere((e) => followedUpRayStates.contains(e));
    }

    return energizedTiles.length;
  }

}

enum _Tile {

  vSplitter('|'),
  hSplitter('-'),
  bMirror('\\'),
  fMirror('/'),
  empty('.');

  final String character;

  const _Tile(this.character);

  static _Tile parseFromCharacter(String character) {
    return switch (character) {
      '|' => _Tile.vSplitter,
      '-' => _Tile.hSplitter,
      '\\' => _Tile.bMirror,
      '/' => _Tile.fMirror,
      '.' => _Tile.empty,
      _ => throw Exception('Cannot parse $character'),
    };
  }

}
