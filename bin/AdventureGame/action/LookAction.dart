import '../character/Character.dart';
import '../character/Player.dart';
import 'Action.dart';

class LookAction implements Action<Character> {
  @override
  Map execute(Player player, c) => {
        ...{'description': '${player.name} looking at ${c.name}'},
        ...c.state(),
      };

  @override
  String getType() => 'look';

  @override
  bool isPossible(Player player) => !player.isDead();
}
