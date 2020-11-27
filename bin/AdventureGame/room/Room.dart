import '../character/Character.dart';
import '../character/Monster.dart';
import '../character/Player.dart';
import '../item/Item.dart';
import 'Direction.dart';

class Room {
  final String name;
  final List<Monster> monsters;
  final List<Item> items;
  final Map<Direction, Room> neighbours;
  List<Player> players;

  Room(this.name)
      : monsters = <Monster>[],
        items = <Item>[],
        neighbours = <Direction, Room>{},
        players = <Player>[];

  void addMonster(Monster m) => monsters.add(m);

  void addItem(Item i) => items.add(i);

  void addNeighbours(Room r, Direction d) {
    if (!neighbours.containsKey(d)) neighbours[d] = r;
  }

  Iterable<Direction> getDirection() => neighbours.keys;

  Room getNeighbour(Direction userDirection) => neighbours[userDirection];

  int numberOfNeighbours() => neighbours.length;

  bool isExit() => false;

  List<int> getGuid(List<Character> list) {
    var guids = <int>[];
    list.forEach((c) => guids.add(c.guid));
    return guids;
  }

  List<int> getGuidEntities() {
    var entities = getGuid(monsters);
    if (players.isNotEmpty) entities.addAll(getGuid(players));
    return entities;
  }

  List<int> getItemsid() {
    var iID = <int>[];
    items.forEach((c) => iID.add(c.getId));
    return iID;
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
        'items': getItemsid()
      };
}
