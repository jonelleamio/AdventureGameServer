import '../character/Character.dart';
import '../character/Player.dart';
import 'Action.dart';

class AttackAction implements Action<Character> {
  @override
  Map execute(Player player, c) {
    var possible = isPossible(player);
    if (possible['bool']) {
      var res;
      if (c.isMob()) {
        // mobs always attack back
        res = {
          '0': {...player.attack(c)},
          '1': {...c.attack(player)}
        };
        if (player.isDead()) {
          player.currentRoom.players.remove(player.guid);
        }
        if (c.isDead()) {
          player.currentRoom.monsters.remove(c.guid);
        }
      } else {
        res = player.attack(c);
        if (c.isDead()) {
          player.currentRoom.players.remove(c.guid);
        }
      }
      return res;
    }
    return possible;
  }

  @override
  Map isPossible(Player player) {
    //check if player is dead
    if (player.isDead()) {
      return {
        'bool': false,
        'r': {'type': 'deadHandler'}
      };
    }
    return {'bool': true};
  }

  @override
  String getType() => 'attack';
}
