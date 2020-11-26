import 'dart:math';

import '../AdventureGame.dart';

abstract class Character {
  int life;
  int strength;
  int gold;
  String name;
  AdventureGame game;
  String type;

  Character(this.life, this.strength, this.gold, this.name, this.type);

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
      'description': '${name} hits ${c.name} \n'
          '${c.name} took ${damage} damage \n'
          '${c.name} have ${c.life} life left',
      'type': c.type,
      'life': c.life,
      'damage': damage,
    };
  }

  bool isDead()
  {
    return life <= 0;
  }

  String die()
  {
    return null;
  }
}