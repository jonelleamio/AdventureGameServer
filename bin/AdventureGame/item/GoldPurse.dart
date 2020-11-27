import '../character/Player.dart';
import 'Item.dart';

class GoldPurse implements Item {
  final int gold;
  final int id;

  @override
  int get getId => id;

  GoldPurse(this.gold, this.id);

  @override
  Map isUsedBy(Player p) {
    p.gold += gold;
    return {
      'description' : '${p.name} gain ${gold} gold',
      'gold' : gold,
      'totalGold': p.gold,
    };
  }

  @override
  Map state() => {
    'description' : '${gold} gold',
    'guid' : id,
    'type': 'GOLD PURSE'
  };

}