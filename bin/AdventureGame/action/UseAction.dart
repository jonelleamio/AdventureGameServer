import '../character/Player.dart';

abstract class Action {
  Map execute (Player player);
  bool isPossible(Player player);
  String getName();
}