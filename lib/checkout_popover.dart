import 'package:flutter/material.dart';
import 'package:pos/bill_return_calculation.dart';
import 'package:pos/incrementor.dart';
import 'package:pos/models.dart';
import 'package:pos/utils.dart';
import 'package:pos/utils/sum_calculation.dart';

class CheckoutPopover extends StatefulWidget {
  final Map<Item, int> currentTransaction;
  void Function() onAddTransaction;


  CheckoutPopover({
    super.key,
    required this.currentTransaction,
    required this.onAddTransaction,
  });

  @override
  State<CheckoutPopover> createState() => _CheckoutPopoverState();
}

class _CheckoutPopoverState extends State<CheckoutPopover> {
  final Map<int, int> _billCounts = {};

  double _sumBillCounts() {
    return _billCounts.keys.fold<double>(0, (acc, bill) {
      return acc + (bill * _billCounts[bill]!);
    });
  }

  @override
  Widget build(BuildContext context) {

    final transactionSum = widget.currentTransaction.calculateSum();
    final billCountSum = _sumBillCounts();

    return Container(
      height: 900,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Amount Due: ${currencyFormat.format(transactionSum)}',
              style: const TextStyle(fontSize: 30),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text('Bills Received'),
                  Incrementor(
                    name: '\$1',
                    count: _billCounts[1] ?? 0,
                    onSetCount: (count) => setState(() => _billCounts[1] = count),
                  ),
                  Incrementor(
                    name: '\$5',
                    count: _billCounts[5] ?? 0,
                    onSetCount: (count) => setState(() => _billCounts[5] = count),
                  ),
                  Incrementor(
                    name: '\$10',
                    count: _billCounts[10] ?? 0,
                    onSetCount: (count) => setState(() => _billCounts[10] = count),
                  ),
                  Incrementor(
                    name: '\$20',
                    count: _billCounts[20] ?? 0,
                    onSetCount: (count) => setState(() => _billCounts[20] = count),
                  ),
                  Incrementor(
                    name: '\$50',
                    count: _billCounts[50] ?? 0,
                    onSetCount: (count) => setState(() => _billCounts[50] = count),
                  ),
                ],
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bills to Return'),
                  BillReturnCalculation(receivedBillSum: billCountSum - transactionSum, billCounts: _billCounts)
                ],
              ),
      
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (transactionSum - billCountSum <= 0) {
                        widget.onAddTransaction();
                      }
                    },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(transactionSum - billCountSum > 0 ? Colors.grey : Colors.green)),
                    child: const Text('Checkout'),
                  ),
                  ElevatedButton(
                    child: const Text('Digital Transaction'),
                    onPressed: () {
                      widget.onAddTransaction();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}