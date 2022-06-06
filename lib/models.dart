class Item {
  final String name;
  final int cost;

  const Item({
    required this.name,
    required this.cost,
  });

  Map<String, dynamic> toJson(int count) {
    return {
      'name': name,
      'cost': cost,
      'count': count,
    };
  }
}

class Transaction {
  DateTime date;
  Map<Item, int> items;

  Transaction(
    this.items,
  ) : date = DateTime.now();

  @override
  String toString() {
    return items.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.microsecondsSinceEpoch,
      'items': Map.fromEntries(
        items.keys.map((item) => MapEntry(item.name, item.toJson(items[item]!))),
      ),
    };
  }
}