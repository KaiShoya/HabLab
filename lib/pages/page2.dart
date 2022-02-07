import 'package:flutter/material.dart';
import '../components/chart.dart';
import '../models/weight_data.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<WeightData> weightList = [
      WeightData(DateTime(2020, 10, 2), 50),
      WeightData(DateTime(2020, 10, 3), 53),
      WeightData(DateTime(2020, 10, 4), 40)
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('2'),
      ),
      body: Center(
        child: ChartWidget(weightList: weightList),
      ),
    );
  }
}
