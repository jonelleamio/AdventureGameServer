import '../character/Monster.dart';
import '../character/Player.dart';
import 'UseAction.dart';

class AttackAction implements Action {
  @override
  Map execute(Player player) {
    var monsters = player.currentRoom.monsters;
    var players = player.currentRoom.players;

  }

  @override
  String getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  bool isPossible(Player player) {
    // TODO: implement isPossible
    throw UnimplementedError();
  }

}