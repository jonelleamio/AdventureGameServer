import 'dart:math';

abstract class Character {
  int life;
  int strength;
  int gold;
  int guid;
  String name;
  String type;

  Character(
      this.life, this.strength, this.gold, this.name, this.guid, this.type);

  Map attack(Character c) {
    var r = Random();
    var chance = (r.nextInt(130 - 70) + 70);
    var damage = ((strength * chance) ~/ 100);
    c.life -= damage;
    if (c.isDead()) {
      gold += c.gold;
    }
    return {
      'description': '${name} hits ${c.name} ${isDead() ? 'before death' : ''},'
      ' ${c.name} took ${damage} damage, '
      '${c.name} have ${c.life} life left.'
      '${c.die()}',
      'type': c.type,
      'guid': c.guid,
      'name': c.name,
      'life': c.life,
      'strength': c.strength,
      'gold': c.gold,
    };
  }

  bool isDead() => life <= 0;

  bool isMob();

  String die();

  Map state();
}
