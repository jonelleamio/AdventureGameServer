import 'Room.dart';

class ExitRoom extends Room {
  ExitRoom(String name) : super(name);

  @override
  bool isExit() => true;
}