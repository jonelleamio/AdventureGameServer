import 'AdventureGame.dart';
import 'character/Player.dart';

void main () {
  const INIT_LIFE = 200;
  const INIT_STRENGTH = 70;
  const INIT_GOLD = 0;
  var game = AdventureGame();
  var player = Player(INIT_LIFE, INIT_STRENGTH, INIT_GOLD, 'player1', 123456789);
  print(game.newPlayer(player));
  print(player.currentRoom.state());
  print(player.actions['move'].execute(player, player.currentRoom.getDirection().elementAt(0)));
  print(player.actions['attack'].execute(player, player.currentRoom.monsters.first));
}

