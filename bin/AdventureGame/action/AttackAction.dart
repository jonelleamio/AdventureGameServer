import '../character/Character.dart';
import '../character/Player.dart';
import 'Action.dart';

class AttackAction implements Action<Character> {

  @override
  Map execute(Player player, c) {
    return player.attack(c);
  }

  @override
  bool isPossible(Player player) => !player.isDead();

  @override
  String getType() => 'attack';

}