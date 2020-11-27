import '../character/Player.dart';

abstract class Item {
  Map isUsedBy(Player player);
  Map state();
  int get getId;
}