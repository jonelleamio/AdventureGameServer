import 'Character.dart';

class Monster extends Character {
  Monster(int life, int strength, int gold, String name, int guid)
      : super(life, strength, gold, name, guid, 'Monster');

  @override
  Map state() => {
        'type': type,
        'guid': guid,
        'name': 'name',
        'life': life,
        'strength': strength,
        'gold': gold,
      };
}
