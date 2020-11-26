import 'dart:collection';
import 'dart:math';

import 'character/Monster.dart';
import 'character/Player.dart';
import 'item/Item.dart';
import 'item/LifePotion.dart';
import 'item/Merchant.dart';
import 'item/StrengthPotion.dart';
import 'room/Direction.dart';
import 'room/Room.dart';

class AdventureGame {
  final MAX_ROOM = 100;
  List<Player> players;
  List<Room> dungeon;
  List<Direction> directions;
  Room startRoom;
  Random r;

  AdventureGame(){
    r = Random();
    directions.add(Direction.NORTH);
    directions.add(Direction.EAST);
    directions.add(Direction.WEST);
    directions.add(Direction.SOUTH);
    createDungeon();
  }

  /// Create rooms and link them together
  /// Initialise startRoom
  /// create new room then link it to parent
  /// push new room into queue
  void createDungeon() {
    createStartRoom();
    var oldRoom = startRoom;
    Room newRoom;
    var level = 1;
    var nbRoom = 0;
    final queue = Queue<Room>();
    do {
      oldRoom.neighbours.forEach((oldDir, current) {
        /// loop on each direction except the reverse of the current direction
        /// to not overwrite parent link
        for (var newDir in oldDir.removeOpp(directions)) {
          if (nbRoom < MAX_ROOM) {
            newRoom = createRoom(nbRoom, level, newDir);
            /// two way - allow player to go back
            current.addNeighbours(newRoom, newDir);
            newRoom.addNeighbours(current, newDir.opposite());
            queue.add(newRoom);
            nbRoom++;
            level++;
          } else {
            /// on MAX_ROOM clear queue and push final room
            queue.clear();
          }
        }
      });
      /// simple FIFO using queue
      oldRoom = queue.first;
      queue.removeFirst();
      level++;
    } while (queue.isNotEmpty);
  }

  /// Initialize startRoom
  void createStartRoom() {
    startRoom = Room('Entrance');
    var newRoom;
    for (var newDir in directions) {
      newRoom = createRoom(0, 0, newDir);
      startRoom.addNeighbours(newRoom, newDir);
      newRoom.addNeighbours(startRoom, newDir.opposite());
    }
  }


  /*
  /// Recursive methode which generates dungeon
  /// Dart is not optimised for recursive even call tail
  /// Risk of memory heap due to large stack of call
  Room newRoom(Room currentRoom, Room oldRoom, Direction oldRoomDirection, int numberRoom) {
    for(var direction in directions) {
      if(direction == oldRoomDirection) {
        currentRoom.addNeighbours(oldRoom, oldRoomDirection);
      }
      else if (numberRoom < MAX_ROOM) {
        if(currentRoom.numberOfNeighbours() > 2 && r.nextBool()) {
          continue;
        } else {
          final room = createRoom(numberRoom, direction);
          final neighbour = newRoom(room, currentRoom, direction.opposite(), numberRoom+1);
          currentRoom.addNeighbours(neighbour, direction);
        }
      } else {
        final exitRoom = Room("exitRoom");
        currentRoom.addNeighbours(exitRoom, direction);
        numberRoom++;
      }
    }
    return currentRoom;
  }
  */

  /// Create room with monsters and items inside
  ///
  /// @roomNb, @directions use only for naming
  /// calls @createMob and @createItem
  Room createRoom(int roomNb, level, Direction direction) {
    // a room can have 1 to 3 items and mobs
    final n = r.nextInt(2) + 1;
    var room = Room('Room${direction}${roomNb}${level}');
    for(var i = 0; i < n; i++) {
      room.addMonster(createMob(level));
      room.addItem(createItem(level));
    }
    return room;
  }

  /// Create monster with level
  ///
  /// Monster stats are randomized and quotient with level
  Monster createMob(int lvl) {
    final level = (lvl + 1) * 0.8;

    final maxL = (150 * level).round();
    final minL = (100 * level).round();
    final life = r.nextInt(maxL - minL) + minL;

    final maxS = (40 * level).round();
    final minS = (20 * level).round();
    final str = r.nextInt(maxS - minS) + minS;

    final gold = r.nextInt((500 * level).round());

    return Monster(life, str, gold, 'Monster${lvl}');
  }

  /// Returns a random Item
  ///
  /// Items stats vary with level
  Item createItem(int lvl) {
    final value = (40 * lvl) + 10;
    Item item;
    switch(r.nextInt(3)) {
      case 0 : item = LifePotion(value); break;
      case 1 : item =  StrengthPotion(value);break;
      case 2 :
        final cost = (2 * lvl) + 10;
        var bag = [];
        bag.add(LifePotion(value));
        bag.add(StrengthPotion(value));
        item = Merchant(cost, bag);
        break;
    }
    return item;
  }
}