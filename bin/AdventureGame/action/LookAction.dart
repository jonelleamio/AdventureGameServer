import '../character/Character.dart';
import '../character/Player.dart';
import 'Action.dart';

class LookAction implements Action<Character> {
  @override
  Map execute(Player player, c) {
    var possible = isPossible(player);
    if (possible['bool']) {
      return {
        ...{'description': '${player.name} looking at ${c.name}'},
        ...c.state(),
      };
    }
    return possible;
  }

  @override
  String getType() => 'look';

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
}
