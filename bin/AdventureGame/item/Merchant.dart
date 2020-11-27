import '../character/Player.dart';
import 'Item.dart';
import 'dart:math';

class Merchant implements Item {
  final int cost;
  final List<Item> bag;
  final int id;

  Merchant(this.cost, this.bag, this.id);

  @override
  int get getId => id;

  @override
  Map isUsedBy(Player p)
  {
    if (p.gold >= cost) {
      p.gold -= cost;
      var i = generateRandomItem();
      var r = i.isUsedBy(p);
      r['cost'] = cost;
      return r;
    } else {
      return {
        'description': "You don't have enough money",
        'gold': p.gold,
        'cost': cost
      };
    }
  }

  Item generateRandomItem()
  {
    var r = Random();
    return bag[r.nextInt(bag.length)];
  }

  @override
  Map state() => {
    'description' : 'A merchant selling item at ${cost} gold',
    'guid' : id,
    'type': 'MERCHANT'
  };
}