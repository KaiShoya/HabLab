import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/amount_data.dart';

class ChartWidget extends StatelessWidget {
  final List<AmountData> amountList;

  const ChartWidget({Key? key, required this.amountList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createAmountData(),
    );
  }

  List<charts.Series<AmountData, DateTime>> _createAmountData() {
    return [
      charts.Series<AmountData, DateTime>(
        id: 'Muscles',
        data: amountList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (AmountData amountData, _) => amountData.date,
        measureFn: (AmountData amountData, _) => amountData.amount,
      )
    ];
  }
}
