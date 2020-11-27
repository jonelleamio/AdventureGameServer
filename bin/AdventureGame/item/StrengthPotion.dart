import '../character/Player.dart';
import 'Item.dart';

class StrengthPotion implements Item {
  final int strength;
  final int id;

  StrengthPotion(this.strength, this.id);

  @override
  int get getId => id;

  @override
  Map isUsedBy(Player p) {
    p.strength += strength;
    return {
      'description' : '${p.name} gain ${strength} strength',
      'strength' : strength,
      'totalStrength': p.strength,
    };
  }

  @override
  Map state() => {
    'description' : '${strength} strength',
    'guid' : id,
    'type': 'STRENGTH POTION'
  };

}