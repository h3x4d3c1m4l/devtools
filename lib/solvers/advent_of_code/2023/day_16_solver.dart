import 'dart:math';

import 'package:h3x_devtools/solvers/advent_of_code/2023/aoc_2023_solver.dart';
import 'package:h3x_devtools/solvers/helpers/extensions.dart';
import 'package:h3x_devtools/solvers/helpers/grid.dart';

typedef RayState = ({int x, int y, Directions direction});

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
    int part1 = _getEnergizedTileCount(grid, 0, 0, Directions.east);

    // Part 2
    int part2 = 0;
    for (int x = 0; x < grid.width; x++) {
      part2 = max(part2, _getEnergizedTileCount(grid, x, 0, Directions.south));
      part2 = max(part2, _getEnergizedTileCount(grid, x, grid.height - 1, Directions.north));
    }
    for (int y = 1; y < grid.height - 1; y++) {
      part2 = max(part2, _getEnergizedTileCount(grid, 0, y, Directions.east));
      part2 = max(part2, _getEnergizedTileCount(grid, grid.width - 1, y, Directions.west));
    }

    return 'Part 1: $part1\nPart 2: $part2';
  }

  int _getEnergizedTileCount(Grid<_Tile> grid, int xStart, int yStart, Directions startDirection) {
    List<RayState> currentBeams = [(x: xStart, y: yStart, direction: startDirection)];
    Set<({int x, int y})> energizedTiles = {};
    Set<RayState> followedUpRayStates = {};

    while (currentBeams.isNotEmpty) {
      List<RayState> beamsToAdd = [];
      for (RayState beam in currentBeams) {
        energizedTiles.add((x: beam.x, y: beam.y));

        bool canGoNorth = beam.y > 0, canGoSouth = beam.y < grid.height - 1;
        bool canGoEast = beam.x < grid.width - 1, canGoWest = beam.x > 0;

        switch (grid.getValue(x: beam.x, y: beam.y)) {
          // Handle '|' and '.'
          case _Tile.vSplitter when beam.direction == Directions.north:
          case _Tile.empty when beam.direction == Directions.north:
            if (canGoNorth) beamsToAdd.add((x: beam.x, y: beam.y - 1, direction: Directions.north));
          case _Tile.vSplitter when beam.direction == Directions.south:
          case _Tile.empty when beam.direction == Directions.south:
            if (canGoSouth) beamsToAdd.add((x: beam.x, y: beam.y + 1, direction: Directions.south));
          case _Tile.vSplitter when beam.direction == Directions.east:
          case _Tile.vSplitter when beam.direction == Directions.west:
            if (canGoNorth) beamsToAdd.add((x: beam.x, y: beam.y - 1, direction: Directions.north));
            if (canGoSouth) beamsToAdd.add((x: beam.x, y: beam.y + 1, direction: Directions.south));

          // Handle '-' and '.'
          case _Tile.hSplitter when beam.direction == Directions.east:
          case _Tile.empty when beam.direction == Directions.east:
            if (canGoEast) beamsToAdd.add((x: beam.x + 1, y: beam.y, direction: Directions.east));
          case _Tile.hSplitter when beam.direction == Directions.west:
          case _Tile.empty when beam.direction == Directions.west:
            if (canGoWest) beamsToAdd.add((x: beam.x - 1, y: beam.y, direction: Directions.west));
          case _Tile.hSplitter when beam.direction == Directions.north:
          case _Tile.hSplitter when beam.direction == Directions.south:
            if (canGoWest) beamsToAdd.add((x: beam.x - 1, y: beam.y, direction: Directions.west));
            if (canGoEast) beamsToAdd.add((x: beam.x + 1, y: beam.y, direction: Directions.east));

          // Handle '\' and '/'
          case _Tile.bMirror when beam.direction == Directions.north:
          case _Tile.fMirror when beam.direction == Directions.south:
            if (canGoWest) beamsToAdd.add((x: beam.x - 1, y: beam.y, direction: Directions.west));
          case _Tile.bMirror when beam.direction == Directions.east:
          case _Tile.fMirror when beam.direction == Directions.west:
            if (canGoSouth) beamsToAdd.add((x: beam.x, y: beam.y + 1, direction: Directions.south));
          case _Tile.bMirror when beam.direction == Directions.south:
          case _Tile.fMirror when beam.direction == Directions.north:
            if (canGoEast) beamsToAdd.add((x: beam.x + 1, y: beam.y, direction: Directions.east));
          case _Tile.bMirror when beam.direction == Directions.west:
          case _Tile.fMirror when beam.direction == Directions.east:
            if (canGoNorth) beamsToAdd.add((x: beam.x, y: beam.y - 1, direction: Directions.north));

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
