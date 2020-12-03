import '../character/Player.dart';
import '../item/Item.dart';
import 'Action.dart';

class UseAction implements Action<Item> {
  @override
  Map execute(Player player, item) {
    item.isUsedBy(player);
  }

  @override
  String getType() => 'use';

  @override
  Map isPossible(Player player) {
    if (player.isDead()) {
      return {
        'bool': false,
        'r': {'type': 'deadHandler'}
      };
    }
    if (player.currentRoom.items.isEmpty) {
      return {
        'bool': false,
        'r': {'type': 'impossible', 'message': 'No more item in room'}
      };
    }
    return {'bool': true};
  }

  
}