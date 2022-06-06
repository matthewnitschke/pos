import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/models.dart';
import 'package:pos/utils.dart';

class TransactionsEditor extends StatelessWidget {

  final List<Transaction> transactions;
  final Function(Transaction) onDeleteTransaction;

  final format = DateFormat('hh:mm a');

  TransactionsEditor({
    super.key,
    required this.transactions,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: transactions.reversed.map((transaction) {
        final summary = transaction.items.keys
          .map((it) => '${it.name}(${transaction.items[it]})')
          .join(', ');

        return Card(
          child: ListTile(
            title: Text(format.format(transaction.date)),
            subtitle: Text(summary),
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              child: Text(currencyFormat.format(transaction.items.calculateSum())),
            ),
            // leading: Text(currencyFormat.format(transaction.items.calculateSum())),
            trailing: IconButton(
              onPressed: () => onDeleteTransaction(transaction),
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      }).toList(),
    );
  }
}