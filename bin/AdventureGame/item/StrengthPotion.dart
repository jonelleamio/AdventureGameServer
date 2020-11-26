import '../character/Player.dart';
import 'Item.dart';

class StrengthPotion implements Item {
  int strength;

  StrengthPotion(this.strength);

  @override
  Map isUsedBy(Player p) {
    p.strength += strength;
    return {
      'description' : '${p.name} gain ${strength} strength',
      'strength' : strength,
      'totalStrength': p.strength,
    };
  }

}