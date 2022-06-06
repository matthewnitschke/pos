import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos/utils.dart';

class SumCalculation extends StatelessWidget {
  final double total;
  final double subtraction;

  const SumCalculation({
    required this.total,
    required this.subtraction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final res = total - subtraction;
    return Row(
      children: [
        Text(
          '${currencyFormat.format(total)} - ${currencyFormat.format(subtraction)} = ',
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          currencyFormat.format(res),
          style: TextStyle(
            fontSize: 20,
            color: res > 0 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}