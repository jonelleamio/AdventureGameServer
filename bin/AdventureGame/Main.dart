import 'dart:core';

// import 'AdventureGame.dart';

void main() {
  // var game = AdventureGame();
  // todo : create console client
}

var entities = [123456789, 987654321];
var items = [1, 2, 3, 4];

// same as create new player
Map connect() {
  return {
    'guid': 123,
    'totalvie': 100,
    'salle': {
      'description': 'Vous êtes dans la première salle',
      'passages': ['N', 'S', 'W'],
      'entites': entities,
      'items': items,
    },
  };
}

Map look(int guid) {
  return {
    'description':
        "Vous êtes dans une salle depuis laquelle on ne peut pas se déplacer à l'ouest (testez pour déclancher une erreur)",
    'passages': ['N', 'S', 'E'],
    'entites': entities,
    'items': items,
  };
}

Map move(int guid, String direction) {
  return {
    'description': 'Vous êtes dans une autre salle',
    'passages': ['N', 'S'],
    'entites': entities,
    'items': items,
  };
}

Map examine(int guidSource, int guidDest) {
  return {
    'description': "L'utilisateur veut examiner",
    'type': 'JOUEUR',
    'vie': 98,
    'totalvie': 100,
  };
}

Map hit(int guidSource, int guidDest) {
  return {
    'description': "L'utilisateur veut taper",
    'type': 'JOUEUR',
    'vie': 98,
    'totalvie': 100,
  };
}
