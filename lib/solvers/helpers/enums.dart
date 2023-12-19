enum Direction {

  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest,

}

enum CardinalDirection {

  north,
  east,
  south,
  west;

  CardinalDirection get opposing => switch (this) {
        CardinalDirection.north => south,
        CardinalDirection.east => west,
        CardinalDirection.south => north,
        CardinalDirection.west => east,
      };

  CardinalDirection get clockwiseNext => switch (this) {
        CardinalDirection.north => east,
        CardinalDirection.east => south,
        CardinalDirection.south => west,
        CardinalDirection.west => north,
      };

  CardinalDirection get clockwisePrevious => switch (this) {
        CardinalDirection.north => west,
        CardinalDirection.west => south,
        CardinalDirection.south => east,
        CardinalDirection.east => north,
      };

}
