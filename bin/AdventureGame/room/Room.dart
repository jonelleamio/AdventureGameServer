import '../character/Monster.dart';
import '../character/Player.dart';
import '../item/Item.dart';
import 'Direction.dart';

class Room
{
  List<Monster> monsters;
  List<Player> players;
  List<Item> items;
  Map<Direction, Room> neighbours;
  String name;

  Room(String n){
    name = n;
  }

  void addMonster(Monster m)
  {
    monsters.add(m);
  }

  void addItem(Item i)
  {
    items.add(i);
  }

  void addNeighbours(Room r, Direction d)
  {
    if (!neighbours.containsKey(d)) {
      neighbours[d] = r;
    }
  }

  List<Direction> getDirection()
  {
    return neighbours.keys;
  }

  Room getNeighbour(Direction userDirection)
  {
    return neighbours[userDirection];
  }

  int numberOfNeighbours()
  {
    return neighbours.length;
  }

 /* String toString()
  {
    return ((((((((("\n#########################\n" + "# You are in ") + this.name) + " #\n") + "#########################\n") + "There are ") + monsters.size()) + " monsters in this place\n") + "There are ") + items.size()) + " items in this place";
  }

  void displayNeighbours()
  {
    Room neighbour;
    for (Direction direction in this.neighbours.keySet()) {
      neighbour = neighbours.get(direction);
      System.out.println("\n***************************************");
      System.out.println(((("*  " + direction) + " -> ") + neighbour.name) + "                 *");
      System.out.println(("*  There are " + neighbour.monsters.size()) + " monsters in this place *");
      System.out.println(("*  There are " + neighbour.items.size()) + " items in this place    *");
      System.out.println("***************************************");
    }
  }*/
}