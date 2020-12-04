import '../character/Monster.dart';
import '../character/Player.dart';
import '../item/Item.dart';
import 'Direction.dart';

class Room {
  final String name;
  final Map<Direction, Room> neighbours;
  final Map<int, Item> items;
  final Map<int, Monster> monsters;
  final Map<int, Player> players;

  Room(this.name)
      : monsters = <int, Monster>{},
        items = <int, Item>{},
        neighbours = <Direction, Room>{},
        players = <int, Player>{};

  void addMonster(Monster m, int id) => monsters[id] = m;

  void addItem(Item i, int id) => items[id] = i;

  void addNeighbours(Room r, Direction d) {
    if (!neighbours.containsKey(d)) neighbours[d] = r;
  }

  Iterable<Direction> getDirection() => neighbours.keys;

  Room getNeighbour(Direction userDirection) => neighbours[userDirection];

  int numberOfNeighbours() => neighbours.length;

  bool isExit() => false;

  List<int> getGuidEntities() {
    var entities = monsters.keys.toList();
    if (players.isNotEmpty) entities.addAll(players.keys.toList());
    return entities;
  }

  List<String> stringDirections() {
    final directions = getDirection();
    var result = <String>[];
    for (var d in directions) {
      result.add(d.toShortString());
    }
    return result;
  }

  Map state() => {
        'description': 'You are in ${name}',
        'directions': stringDirections(),
        'totalEntities': players.length + monsters.length,
        'entities': getGuidEntities(),
        'items': items.keys.toList()
      };
}
