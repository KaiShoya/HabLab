import 'package:flutter/material.dart';
import '../components/listview.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1'),
      ),
      body: const Center(
        child: ListViewWidget(items: [
          'items1',
          'items2',
          'items3',
          'items4',
          'items5',
          'items6',
          'items7',
          'items8',
          'items9',
          'items10',
        ]),
      ),
    );
  }
}
