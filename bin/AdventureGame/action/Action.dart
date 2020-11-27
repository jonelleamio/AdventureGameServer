import '../character/Player.dart';

abstract class Action<T> {
  Map execute (Player player, T value);
  bool isPossible(Player player);
  String getType();
}