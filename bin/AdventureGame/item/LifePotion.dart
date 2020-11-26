import '../character/Player.dart';
import 'Item.dart';

class LifePotion implements Item {
  int life;

  LifePotion(this.life);

  @override
  Map isUsedBy(Player p) {
    p.life += life;
    return {
      'description' : '${p.name} gain ${life} life',
      'life' : life,
      'totalLife': p.life,
    };
  }
}