import '../character/Player.dart';
import '../room/Direction.dart';
import 'Action.dart';

class MoveAction implements Action<Direction> {

  @override
  Map execute(Player player, userDirection) {
    if(isPossible(player)) {
      player.currentRoom = player.currentRoom.getNeighbour(userDirection);
      return player.currentRoom.state();
    }
    return {'type': 'MUR', 'message': 'Vous avez pris un mur'};
  }

  @override
  bool isPossible(Player player) {
    var room = player.currentRoom;
    //check if room still have monsters
    if(room.monsters.isNotEmpty) {
      return false;
    }
    //check if player is dead
    if(player.isDead()) {
      return false;
    }
    //check if game is finish
    if (room.isExit()) {
      return false;
    }
    return true;
  }

  @override
  String getType() => 'move';

}