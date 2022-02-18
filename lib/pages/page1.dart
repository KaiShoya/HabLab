import 'package:flutter/material.dart';
import 'package:hablab/components/listview.dart';
import 'package:hablab/components/chart.dart';
import 'package:hablab/models/amount_data.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  static final AmountDataList _amountList = AmountDataList();
  final AmountDataProvider provider = AmountDataProvider();

  Future<void> setEvents() async {
    // // 2022年のデータを取得する
    // List<AmountData> data = await AmountDataProvider().get1Year(2022);
    // var groupingData = groupBy(data, (AmountData obj) => obj.date);
    // TODO: Dummy data.
    _amountList.update(await provider.get1Month(2022, 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1'),
      ),
      body: Center(
        child: FutureBuilder(
          future: setEvents(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.error != null) {
              return const Text('エラーが発生しました');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: ChartWidget(amountList: _amountList.list),
                ),
                Expanded(
                  child: ListViewWidget(
                    items:
                        _amountList.list.map((e) => e.formatString()).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
