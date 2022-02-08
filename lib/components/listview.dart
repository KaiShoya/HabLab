import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  final List<String> items;

  const ListViewWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // padding: const EdgeInsets.all(8.0),
        itemCount: items.length,
        itemBuilder: (context, i) {
          return _buildRow(items[i]);
        });
  }

  Widget _buildRow(String text) {
    return ListTile(
      title: Text(
        text,
      ),
    );
  }
}
