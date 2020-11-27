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
  bool isPossible(Player player) {
    if(player.isDead()) {
      return false;
    }
    if(player.currentRoom.items.isEmpty) {
      return false;
    }
    return true;
  }

  
}