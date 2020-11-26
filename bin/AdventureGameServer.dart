library urls;

import 'dart:async';
// import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:route2/server.dart';


var entities = [123456789, 987654321];
var items = [1,2,3,4];

final homeUrl = UrlPattern(r'/');
final connexionUrl = UrlPattern(r'/connect');
final regarderUrl = UrlPattern(r'/(\d+)/regarder');
final deplacementUrl = UrlPattern(r'/(\d+)/deplacement');
final examinerUrl = UrlPattern(r'/(\d+)/examiner/(\d+)');
final taperUrl = UrlPattern(r'/(\d+)/taper/(\d+)');

// final allUrls = [homeUrl,connexionUrl,regarderUrl,deplacementUrl,examinerUrl,taperUrl];

Future main() async {

  // var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4042);
  await HttpServer.bind(InternetAddress.loopbackIPv4, 4042)
      .then((server) {
    Router(server)
      ..serve(homeUrl).listen(serverHome)
      ..serve(connexionUrl, method: 'POST').listen(serverConnect)
      ..serve(regarderUrl, method: 'GET').listen(serverRegarder)
      ..serve(deplacementUrl, method: 'GET').listen(serverDeplacement)
      ..serve(examinerUrl, method: 'GET').listen(serverExaminer)
      ..serve(taperUrl, method: 'GET').listen(serverTaper)
      ..defaultStream.listen(noPostHandle);
    print('Listening on http://${server.address.address}:${server.port}/');
  });
}

void serverHome (HttpRequest request){
  print('serverHome');
  request.response
    ..statusCode = HttpStatus.ok
    ..writeln("Bienvenu sur le serveur de test, vous pouvez vous servir de cette URL pour faire vos tests de client MUD tant qu'un seveur n'est pas encore codé par un de vos camarades")
    ..close();
}

void serverConnect(HttpRequest request) {
  print('serverConnect');
  final result = {
    'guid': newUser(),
    'totalvie': 100,
    'salle': {
      'description': 'Vous êtes dans la première salle',
      'passages': ['N', 'S', 'W'],
      'entites': entities,
      'items': items,
    },
  };
  request.response
    ..statusCode = HttpStatus.created
    ..writeln(result)
    ..close();
}

void serverRegarder(HttpRequest request) {
  final guid = (request.uri).toString().split('/')[1];
  if(isEntity(guid)) {
    final result = {
      'description': "Vous êtes dans une salle depuis laquelle on ne peut pas se déplacer à l'ouest (testez pour déclancher une erreur)",
      'passages': ['N', 'S', 'E'],
      'entites': entities,
      'items': items,
    };
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln(result)
      ..close();
    print('serverRegarder ${HttpStatus.ok}');
    return;
  }
  request.response
    ..statusCode = HttpStatus.notFound
    ..writeln({'error':
    'GUID inconnu, veuillez ecrire le bon id ou de créer un nouveau via /connect'
    })
    ..close();
  print('serverRegarder ${HttpStatus.notFound}');
}

void serverDeplacement(HttpRequest request) {
  final guid = (request.uri).toString().split('/')[1];
  if(isEntity(guid)) {
    final result = {
      'description': 'Vous êtes dans une autre salle',
      'passages': ['N', 'S'],
      'entites': entities,
      'items': items,
    };
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln(result)
      ..close();
    print('serverRegarder ${HttpStatus.ok}');
    return;
  }
  request.response
    ..statusCode = HttpStatus.notFound
    ..writeln({'error':
    'GUID inconnu, veuillez ecrire le bon id ou de créer un nouveau via /connect'
    })
    ..close();
  print('serverRegarder ${HttpStatus.notFound}');
}

void serverExaminer(HttpRequest request) {
  final sguid = (request.uri).toString().split('/')[1];
  final dguid = (request.uri).toString().split('/')[3];
  if(isEntity(sguid) && isEntity(dguid)) {
    final result = {
      'description': "L'utilisateur veut examiner",
      'type': 'JOUEUR',
      'vie': 98,
      'totalvie': 100,
    };
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln(result)
      ..close();
    print('serverExaminer ${HttpStatus.ok}');
    return;
  }
  request.response
    ..statusCode = HttpStatus.notFound
    ..writeln({'error':
    'GUID inconnu, veuillez ecrire le bon id ou de créer un nouveau via /connect'
    })
    ..close();
  print('serverRegarder ${HttpStatus.notFound}');
}

void serverTaper(HttpRequest request) {
  final sguid = (request.uri).toString().split('/')[1];
  final dguid = (request.uri).toString().split('/')[3];
  if(isEntity(sguid) && isEntity(dguid)) {
    final result =  {
      'description': "L'utilisateur veut taper",
      'type': 'JOUEUR',
      'vie': 98,
      'totalvie': 100,
    };
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln(result)
      ..close();
    print('serverTaper ${HttpStatus.ok}');
    return;
  }
  request.response
    ..statusCode = HttpStatus.notFound
    ..writeln({'error':
    'GUID inconnu, veuillez ecrire le bon id ou de créer un nouveau via /connect'
    })
    ..close();
  print('serverTaper ${HttpStatus.notFound}');
}

void noPostHandle(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..writeln({'error': 'Requette invalide !'})
    ..close();
}

int newUser() {
  final now = DateTime.now();
  final year = now.year.toString();
  final newYear = year.substring(year.length - 2);
  final uid = '${newYear}${now.month }${now.day}${now.hour}${now.minute}${now.second}';
  final i = int.parse(uid);
  entities.add(i);
  return i;
}

bool isEntity(String uid) {
  final gui = int.tryParse(uid) ?? 0;
  return (gui >= 0 && entities.contains(gui));
}

void deadHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..writeln({"type": "MORT", "message": "Vous êtes mort (pas de bol)"})
    ..close();
}

void sameRoomHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..writeln({"type": "DIFFSALLE", "message": "Vous n'êtes pas dans la même salle"})
    ..close();
}

void wallHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.conflict
    ..writeln({"type": "MUR", "message": "Vous avez pris un mur"})
    ..close();
}
