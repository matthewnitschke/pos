import 'package:flutter/material.dart';
import 'package:pos/models.dart';

class DrinkCounts extends StatelessWidget {
  final List<Item> _items;
  final List<Transaction> _transactions;

  const DrinkCounts({
    super.key,
    required List<Item> items,
    required List<Transaction> transactions,
  }) : 
    _items = items,
    _transactions = transactions;

  @override
  Widget build(BuildContext context) {
    final itemCounts = Map.fromEntries(
      _items.map((item) => MapEntry(item, _countItems(item))),
    );

    final sortedItems = List.from(_items);
    sortedItems.sort((a, b) {
      return itemCounts[b]!.compareTo(itemCounts[a]!);
    });

    return DataTable(
      columns: const [
        DataColumn(label: Text('Drink')),
        DataColumn(
          label: Text('Count'),
          numeric: true,
        )
      ],
      rows: sortedItems.map((item) {
        final count = _countItems(item);
        return DataRow(cells: [
          DataCell(Text(item.name)),
          DataCell(Text(count.toString()))
        ],);
      }).toList()
    );
  }

  int _countItems(Item item) {
    return _transactions.fold<int>(0, (totalAcc, transaction) {
      return transaction.items.keys.fold<int>(totalAcc, (transAcc, transItem) {
        if (transItem == item) {
          return transAcc + transaction.items[transItem]!;
        }
        return transAcc;
      });
    });
  }
}