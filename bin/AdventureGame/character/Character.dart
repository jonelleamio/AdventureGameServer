import 'dart:math';

import '../AdventureGame.dart';

abstract class Character {
  int life;
  int strength;
  int gold;
  int guid;
  String name;
  AdventureGame game;
  String type;

  Character(this.life, this.strength, this.gold, this.name, this.guid, this.type);

  Map attack(Character c)
  {
    var r = Random();
    var chance = (r.nextInt(130 - 70) + 70);
    var damage = ((strength * chance) ~/ 100);
    c.life -= damage;
    if (c.isDead()) {
      c.die();
      gold += c.gold;
    }
    return {
      'description': '${name} hits ${c.name}, '
          '${c.name} took ${damage} damage, '
          '${c.name} have ${c.life} life left',
      'type': c.type,
      'life': c.life,
      'damage': damage,
    };
  }

  bool isDead() => life <= 0;

  String die() => null;

  Map state();
}