import '../action/Action.dart';
import '../action/AttackAction.dart';
import '../action/LookAction.dart';
import '../action/MoveAction.dart';
import '../action/UseAction.dart';
import '../room/Room.dart';
import 'Character.dart';

class Player extends Character {
  Room currentRoom;
  Map<String, Action> actions;

  Player(int life, int strength, int gold, String name, int guid)
      : super(life, strength, gold, name, guid, 'Player') {
    actions = <String, Action>{};
    actions['attack'] = AttackAction();
    actions['look'] = LookAction();
    actions['move'] = MoveAction();
    actions['use'] = UseAction();
  }

  @override
  Map state() => {
        'type': type,
        'guid': guid,
        'name': 'name',
        'life': life,
        'strength': strength,
        'gold': gold,
        'currentRoom': currentRoom.state()
      };
}
