import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/weight_data.dart';

class ChartWidget extends StatelessWidget {
  final List<WeightData> weightList;

  const ChartWidget({Key? key, required this.weightList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createWeightData(),
    );
  }

  List<charts.Series<WeightData, DateTime>> _createWeightData() {
    return [
      charts.Series<WeightData, DateTime>(
        id: 'Muscles',
        data: weightList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (WeightData weightData, _) => weightData.date,
        measureFn: (WeightData weightData, _) => weightData.weight,
      )
    ];
  }
}
