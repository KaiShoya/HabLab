import 'dart:math';

import 'package:flutter/material.dart';
import '../components/listview.dart';
import '../components/chart.dart';
import '../models/amount_data.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  static final AmountDataList _amountList = AmountDataList();
  final AmountDataProvider provider = AmountDataProvider();
  DateTime date = DateTime(2022, 1, 5);

  _Page1State() {
    provider.get1Month(2022, 1).then((data) => _amountList.update(data));
  }

  void _incrementCounter() {
    setState(() {
      date = date.add(const Duration(days: 1));
      _amountList.add(AmountData(date, 1, Random.secure().nextDouble() * 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1'),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        SizedBox(height: 300, child: ChartWidget(amountList: _amountList.list)),
        Expanded(
            child: ListViewWidget(
                items: _amountList.list.map((e) => e.formatString()).toList())),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
