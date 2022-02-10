import 'package:intl/intl.dart';
const String tableAmountData = 'amount_data';
const String columnId = 'id';
const String columnDate = 'date';
const String columnAmount = 'amount';

class AmountData {
  int? id;
  DateTime date;
  double amount;

  AmountData(this.id, this.date, this.amount);

  String formatString() {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(date) + " " + amount.toString();
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{columnDate: date, columnAmount: amount};
    return map;
  }
}

class AmountDataList {
  List<AmountData> list = [];
  AmountDataList();

  void add(AmountData data) {
    list.add(data);
  }
}

