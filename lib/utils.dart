
import 'package:intl/intl.dart';
import 'package:pos/models.dart';

final currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 0);

extension SumItems on Map<Item, int> {
  double calculateSum() {
    return keys.fold<double>(0, (acc, item) => acc + item.cost * this[item]!);
  }
}