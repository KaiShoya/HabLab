import 'package:flutter/material.dart';
import '../components/chart.dart';
import '../models/amount_data.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AmountData> amountList = [];
    AmountDataProvider().open().then((provider) =>
        provider.get1Month(2022, 1).then((data) => amountList = data));
    return Scaffold(
      appBar: AppBar(
        title: const Text('2'),
      ),
      body: Center(
        child: ChartWidget(amountList: amountList),
      ),
    );
  }
}
