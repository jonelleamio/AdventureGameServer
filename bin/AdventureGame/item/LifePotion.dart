import '../character/Player.dart';
import 'Item.dart';

class LifePotion implements Item {
  final int life;
  final int id;

  @override
  int get getId => id;

  LifePotion(this.life, this.id);

  @override
  Map isUsedBy(Player p) {
    p.life += life;
    return {
      'description' : '${p.name} gain ${life} life',
      'life' : life,
      'totalLife': p.life,
    };
  }

  @override
  Map state() => {
    'description' : '${life} life',
    'guid' : id,
    'type': 'LIFE POTION'
  };
}