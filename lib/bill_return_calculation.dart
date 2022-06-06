import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos/utils.dart';

class BillReturnCalculation extends StatelessWidget {

  double receivedBillSum;
  final Map<int, int> billCounts;

  BillReturnCalculation({
    required this.receivedBillSum,
    required this.billCounts,
    super.key
  });

  Map<int, int> _calculateReturnBills(double sum) {
    final bills = [50, 20, 10, 5, 1];

    final aggregate = <int, int>{};
    while (sum > 0) {
      final bill = bills.firstWhere((b) => b <= sum);

      aggregate.putIfAbsent(bill, () => 0);
      aggregate[bill] = aggregate[bill]! + 1;
      sum -= bill;
    }

    return aggregate;
  }

  @override
  Widget build(BuildContext context) {
    final returnBills = _calculateReturnBills(receivedBillSum);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: returnBills.keys.map((bill) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              returnBills[bill].toString(),
              style: const TextStyle(
                fontSize: 25,
              )
            ),
            const Text(
              ' x ',
              style: TextStyle(color: Colors.grey)
            ),
            Text(
              currencyFormat.format(bill),
              style: const TextStyle(fontSize: 25),
            ),
          ],
        );
      }).toList(),
    );

    // return Text(returnBills.toString());
  }
}