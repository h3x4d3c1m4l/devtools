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

}
