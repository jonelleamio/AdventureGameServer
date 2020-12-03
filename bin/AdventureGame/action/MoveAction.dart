import '../character/Player.dart';
import '../room/Direction.dart';
import 'Action.dart';

class MoveAction implements Action<Direction> {
  @override
  Map execute(Player player, userDirection) {
    var possible = isPossible(player);
    if (possible['bool']) {
      // store current room in variable to remove player inside
      var oldRoom = player.currentRoom;
      var newRoom = oldRoom.getNeighbour(userDirection);
      // change player's current room
      player.currentRoom = newRoom;
      // remove player from old room
      oldRoom.players.remove(player.guid);
      // add player into new room
      newRoom.players[player.guid] = player;
      // return new rooms state
      return newRoom.state();
    }
    return possible['r'];
  }

  @override
  Map isPossible(Player player) {
    var room = player.currentRoom;
    //check if room still have monsters
    if (room.monsters.isNotEmpty) {
      return {
        'bool': false,
        'r': {'type': 'other', 'message': 'Il faut eliminer les monstres'}
      };
    }
    //check if player is dead
    if (player.isDead()) {
      return {
        'bool': false,
        'r': {'type': 'deadHandler'}
      };
    }
    //check if game is finish
    if (room.isExit()) {
      return {
        'bool': false,
        'r': {'type': 'exitHandler'}
      };
    }
    return {'bool': true};
  }

  @override
  String getType() => 'move';
}
