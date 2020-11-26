import 'character/Monster.dart';
import 'character/Player.dart';

void main () {
  const INIT_LIFE = 200;
  const INIT_STRENGTH = 70;
  const INIT_GOLD = 0;
  var player = Player(INIT_LIFE, INIT_STRENGTH, INIT_GOLD, 'player1',123456789);
  var player2 = Player(INIT_LIFE, INIT_STRENGTH, INIT_GOLD, 'player2',987654321);
  var monster = Monster(INIT_LIFE, INIT_STRENGTH, INIT_GOLD, 'monster');
  print(player.attack(player2));
  print(player2.attack(monster));
  print(monster.attack(player));
  print(player);
}

