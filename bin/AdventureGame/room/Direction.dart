enum  Direction {
  NORTH,
  SOUTH,
  EAST,
  WEST
}

extension DirectionExtension on Direction {
  Direction opposite() {
    switch(this) {
      case Direction.NORTH : return Direction.SOUTH;
      case Direction.SOUTH : return Direction.NORTH;
      case Direction.EAST : return Direction.WEST;
      case Direction.WEST : return Direction.EAST;
    }
    return null;
  }
  List<Direction> removeOpp(List<Direction> d) {
    d..remove(opposite())
      ..shuffle();
    return d;
  }
}