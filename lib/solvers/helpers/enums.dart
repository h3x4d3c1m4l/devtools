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

  CardinalDirection get nextClockwise => switch (this) {
        CardinalDirection.north => east,
        CardinalDirection.east => south,
        CardinalDirection.south => west,
        CardinalDirection.west => north,
      };

  CardinalDirection get previousClockwise => switch (this) {
        CardinalDirection.north => west,
        CardinalDirection.east => north,
        CardinalDirection.south => east,
        CardinalDirection.west => south,
      };

}
