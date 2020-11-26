import '../character/Player.dart';
import 'Item.dart';
import 'dart:math';

class Merchant implements Item {
  int cost;
  List<Item> bag;

  Merchant(this.cost, this.bag);

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
}