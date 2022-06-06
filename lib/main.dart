import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos/checkout_popover.dart';
import 'package:pos/incrementor.dart';
import 'package:pos/models.dart';
import 'package:pos/stats_widgets/drink_counts.dart';
import 'package:pos/stats_widgets/profit_summary.dart';
import 'package:pos/transactions_editor.dart';
import 'package:pos/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Point of Sale'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _items = [
    const Item(name: 'Americano', cost: 3),
    const Item(
      name: 'Latte', 
      cost: 4, 
    ),
    const Item(
      name: 'Flavored Latte', 
      cost: 5, 
    ),
    const Item(
      name: 'Steamer',
      cost: 3,
    ),
  ];
  
  final List<Transaction> _transactions = [];

  var _currentTransaction = <Item, int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final data = _transactions.map((transaction) => transaction.toJson()).toList();
          Clipboard.setData(ClipboardData(text: jsonEncode(data)));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.import_export),
      ),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: _items.map((item) =>
                  Incrementor(
                    name: item.name,
                    count: _currentTransaction[item] ?? 0,
                    onSetCount: (newCount) {
                      setState(() {
                        _currentTransaction = {
                          ..._currentTransaction,
                          item: newCount
                        };
                      });
                    },
                    buttonStyle: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        const Size(150, 100)
                      ),
                    ),
                  )
                ).toList(),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green[400]),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (ctx) => CheckoutPopover(
                        currentTransaction: _currentTransaction,
                        onAddTransaction: () {
                          setState(() {
                            _transactions.add(Transaction(Map.from(_currentTransaction)));
                            _currentTransaction = {};
                          });

                          Navigator.pop(ctx);
                        }
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                    child: Text(
                      'Checkout \$${_currentTransaction.calculateSum()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
              child: TransactionsEditor(
                transactions: _transactions,
                onDeleteTransaction: (transaction) {
                  setState(() {
                    _transactions.remove(transaction);
                  });
                },
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 20),
                child: ProfitSummary(operatingCosts: 196, transactions: _transactions),
              ),
              DrinkCounts(items: _items, transactions: _transactions),
            ],
          )
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
