library urls;

import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'dart:io';

import 'package:route2/server.dart';

import 'AdventureGame/AdventureGame.dart';

AdventureGame GAME;
var players = [];
var items = [];

final homeUrl = UrlPattern(r'/');
final connexionUrl = UrlPattern(r'/connect');
final regarderUrl = UrlPattern(r'/(\d+)/regarder');
final deplacementUrl = UrlPattern(r'/(\d+)/deplacement');
final examinerUrl = UrlPattern(r'/(\d+)/examiner/(\d+)');
final taperUrl = UrlPattern(r'/(\d+)/taper/(\d+)');

// final allUrls = [homeUrl,connexionUrl,regarderUrl,deplacementUrl,examinerUrl,taperUrl];

Future main() async {
  GAME = AdventureGame();
  print('ADVENTURE GAME CREATED');

  // var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4042);
  await HttpServer.bind(InternetAddress.loopbackIPv4, 4042).then((server) {
    Router(server)
      ..serve(homeUrl).listen(serverHome)
      ..serve(connexionUrl, method: 'POST').listen(serverConnect)
      ..serve(regarderUrl, method: 'GET').listen(serverRegarder)
      ..serve(deplacementUrl, method: 'POST').listen(serverDeplacement)
      ..serve(examinerUrl, method: 'GET').listen(serverExaminer)
      ..serve(taperUrl, method: 'GET').listen(serverTaper)
      ..defaultStream.listen(noPostHandle);
    print('Listening on http://${server.address.address}:${server.port}/');
  });
}

void serverHome(HttpRequest request) {
  print('call serverHome');
  var welcome = {
    'type': 'welcome',
    'message': 'Welcome to the world of undead'
        'Heres what you can do :'
        '- POST <url>/connect '
        '- GET  <url>/<GUID>/regarder '
        '- POST <url>/<GUID>/deplacement '
        '  data can be json or x-www-form-urlencoded '
        '  {"direction": "N" | "S" | "E" | "W"} '
        '- GET  <url>/<guidsource>/examiner/<guiddest> '
        '- POST <url>/<guidsource>/taper/<guidcible> '
        'Known errors '
        '- {"type": "NOTPLAYER", "message":".."} '
        '- {"type": "MORT", "message":".."} '
        '- {"type": "DIFFSALLE", "message":".."} '
        '- {"type": "MUR", "message":".."} '
        '- {"type": "NOTDIRECTION", "message":".."} '
        '- {"type": "EXIT", "message":".."} '
        '- {"type": "ERROR", "message":".."} '
  };
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(welcome))
    ..close();
  print('<200> serverHome');
}

void serverConnect(HttpRequest request) {
  print('call serverConnect');
  final guid = newUser();
  request.response
    ..statusCode = HttpStatus.created
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(GAME.newPlayer(guid)))
    ..close();
  print('new player created | id:${guid}');
  print('<201> serverConnect');
}

void serverRegarder(HttpRequest request) {
  final guid = (request.uri).toString().split('/')[1];
  final id = int.tryParse(guid) ?? 0;
  print('#${guid} tries to look');

  // check if player exist else return error
  if (isNotPlayer(id)) {
    print('<404> | #${id} | ${guid} is not a player');
    notPlayerHandler(request);
    return;
  }

  final result = GAME.players[id].currentRoom.state();

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(result))
    ..close();
  print('<200> | #${id} | serverRegarder');
}

Future<void> serverDeplacement(HttpRequest request) async {
  final guid = (request.uri).toString().split('/')[1];
  final id = int.tryParse(guid) ?? 0;
  print('#${guid} tries to move');

  // check if player exist else return error
  if (isNotPlayer(id)) {
    print('<404> | #${id} | ${guid} is not a player');
    notPlayerHandler(request);
    return;
  }

  var decoded;
  // allow clients that are running on a different origin
  addCorsHeaders(request.response);

  // try to get post request and transform as Map
  try {
    decoded = await getPostData(request);
  } catch (e) {
    print('<400> | #${id} | Request listen error: $e');
    noPostHandle(request);
    return;
  }

  // error badRequest not a valid json
  if (!decoded.containsKey('direction')) {
    print('<400> | #${id} | "direction" key not found');
    errorHandler(request, 'ERROR', '"direction" key not found', 400);
    return;
  }

  final player = GAME.players[id];
  final direction = GAME.stringToDirection(decoded['direction']);

  // check if valid direction input
  if (direction == null) {
    print('<409> | #${id} | direction Not Found');
    wrongDirectionHandler(request, decoded['direction']);
    return;
  }

  /// All datas are good we can now execute  move action
  final result = player.actions['move'].execute(player, direction);

  // check if move action executed properly
  if (result.containsKey('type')) {
    switch (result['type']) {
      case 'other':
        print('<409> | #${id} | ${result["message"]}');
        errorHandler(request, 'ERROR', result['message'], HttpStatus.conflict);
        return;
      case 'deadHandler':
        print('<409> | #${id} | player is dead');
        deadHandler(request);
        return;
      case 'exitHandler':
        print('<409> | #${id} | exit room');
        exitHandler(request);
        return;
    }
  }

  // if everything gone good
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(result))
    ..close();
  print('<200> | #${id} | serverDeplacement');
}

void serverExaminer(HttpRequest request) {
  final sguid = (request.uri).toString().split('/')[1];
  final dguid = (request.uri).toString().split('/')[3];
  final sid = int.tryParse(sguid) ?? 0;
  final did = int.tryParse(dguid) ?? 0;
  print('#${sguid} tries to check #${dguid}');

  // check if player exist else return error
  if (isNotPlayer(sid)) {
    print('<404> | #${sid} | is not a player');
    notPlayerHandler(request);
    return;
  }

  // get player from id
  final player = GAME.players[sid];
  var target;

  // find target
  if (player.currentRoom.monsters.containsKey(did)) {
    target = player.currentRoom.monsters[did];
    print('#${sid} | target found ${did} is type monster');
  } else if (player.currentRoom.players.containsKey(did)) {
    print('#${sid} | target found ${did} is type player');
    target = player.currentRoom.players[did];
  } else {
    print('<409> | #${sid} | #${did} | Not same room');
    sameRoomHandler(request);
    return;
  }

  // target found execute look action
  final result = player.actions['look'].execute(player, target);

  // check if move action executed properly
  if (result.containsKey('bool')) {
    if (result['type' == 'deadHandler']) {
      print('<409> | #${sid} | player is dead');
      deadHandler(request);
      return;
    }
  }

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(result))
    ..close();
  print('<200> | #${sid} | #${did} | serverExaminer');
}

void serverTaper(HttpRequest request) {
  final sguid = (request.uri).toString().split('/')[1];
  final dguid = (request.uri).toString().split('/')[3];
  final sid = int.tryParse(sguid) ?? 0;
  final did = int.tryParse(dguid) ?? 0;
  print('#${sguid} tries to hit #${dguid}');

  // check if player exist else return error
  if (isNotPlayer(sid)) {
    print('<404> | #${sid} | is not a player');
    notPlayerHandler(request);
    return;
  }

  // get player from id
  final player = GAME.players[sid];
  var target;

  // find target
  if (player.currentRoom.monsters.containsKey(did)) {
    target = player.currentRoom.monsters[did];
  } else if (player.currentRoom.players.containsKey(did)) {
    target = player.currentRoom.players[did];
  } else {
    print('<409> | #${sid} | #${did} | Not same room');
    sameRoomHandler(request);
    return;
  }

  // target found execute look action
  final result = player.actions['attack'].execute(player, target);

  // check if move action executed properly
  if (result.containsKey('bool')) {
    if (result['type' == 'deadHandler']) {
      print('<409> | #${sid} | player is dead');
      deadHandler(request);
    }
  }

  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(result))
    ..close();
  print('<200> | #${sid} | #${did} | serverTaper');
}

void noPostHandle(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({'error': 'Requette invalide !'}))
    ..close();
}

/// returns new unique guid
int newUser() {
  final now = DateTime.now();
  final year = now.year.toString();
  final newYear = year.substring(year.length - 2);
  final uid =
      '${newYear}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  final i = int.parse(uid);
  players.add(i);
  return i;
}

/// check if player does not exists
bool isNotPlayer(int uid) {
  return (uid == 0 || !players.contains(uid));
}

/// 1/ Check if post data is correct (json or x-www-form-urlencoded)
/// else error
/// 2/ decode request in utf8
/// 3/ decode as json / list
/// 4/ if list -> parse as Map
Future<Map> getPostData(HttpRequest request) async {
  Map response;
  final mimeType = request.headers.contentType?.mimeType;
  // 1
  if (mimeType == 'application/json') {
    // 2
    final content = await utf8.decoder.bind(request).join();
    // 3
    response = jsonDecode(content) as Map;
    print('application/json : ${response}');
  }
  // 1
  else if (mimeType == 'application/x-www-form-urlencoded') {
    // 2
    final content = await utf8.decoder.bind(request).join();
    // 3
    final l = content.split('=');
    response = {
      // 4
      for (var i = 0; i < l.length; i += 2) l[i]: l[i + 1]
    };
    print('application/x-www-form-urlencoded : ${response}');
  } else {
    print('invalid type : ${request.headers.contentType?.mimeType}');
    noPostHandle(request);
    return null;
  }
  return response;
}

void notPlayerHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({
      'type': 'NOTPLAYER',
      'message':
          'GUID inconnu, veuillez ecrire le bon id ou de créer un nouveau via /connect'
    }))
    ..close();
}

void deadHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..headers.contentType = ContentType.json
    ..write(
        jsonEncode({'type': 'MORT', 'message': 'Vous êtes mort (pas de bol)'}))
    ..close();
}

void sameRoomHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(
        {'type': 'DIFFSALLE', 'message': "Vous n'êtes pas dans la même salle"}))
    ..close();
}

void wallHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({'type': 'MUR', 'message': 'Vous avez pris un mur'}))
    ..close();
}

void wrongDirectionHandler(HttpRequest request, String d) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(
        {'type': 'NOTDIRECTION', 'message': "La direction ${d} n'existe pas"}))
    ..close();
}

void exitHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({
      'type': 'EXIT',
      'message': 'Vous ne pouvez plus bouger, vous etes à la sortie !'
    }))
    ..close();
}

void errorHandler(HttpRequest request, String type, String message, int code) {
  request.response
    ..statusCode = code
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({
      'type': type,
      'message': message,
    }))
    ..close();
}

void addCorsHeaders(HttpResponse response) {
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}
