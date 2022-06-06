import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/models.dart';
import 'package:pos/utils/sum_calculation.dart';
import 'package:pos/utils.dart';

class ProfitSummary extends StatelessWidget {
  final double _operatingCosts;
  final List<Transaction> _transactions;

  ProfitSummary({
    super.key,
    required double operatingCosts,
    required List<Transaction> transactions,
  }) : 
    _operatingCosts = operatingCosts,
    _transactions = transactions;

  @override
  Widget build(BuildContext context) {
    final revenue = _calculateRevenue();

    return SumCalculation(
      total: revenue,
      subtraction: _operatingCosts,
    );
  }

  double _calculateRevenue() {
    return _transactions.fold<double>(0, (totalAcc, transaction) {
      return transaction.items.keys.fold<double>(
        totalAcc, 
        (transAcc, transItem) {
          return transAcc + (transaction.items[transItem]! * transItem.cost);
        },
      );
    });
  }
}