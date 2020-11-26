import '../character/Player.dart';
import 'Item.dart';

class GoldPurse implements Item {
  int gold;

  @override
  Map isUsedBy(Player p) {
    p.gold += gold;
    return {
      'description' : '${p.name} gain ${gold} gold',
      'gold' : gold,
      'totalGold': p.gold,
    };
  }

}