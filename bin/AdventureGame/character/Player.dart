import '../room/Room.dart';
import 'Character.dart';

class Player extends Character {
  int guid;
  Room currentRoom;
  Player(int life, int strength, int gold, String name, this.guid) : super(life, strength, gold, name, 'Player');

  Map state(){
    return{
      'guid': guid,
      'name': 'name',
      'life': life,
      'strength': strength,
      'gold':gold,
      'currentRoom': currentRoom
    };
  }
}