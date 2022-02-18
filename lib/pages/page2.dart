import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hablab/l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hablab/models/amount_data.dart';
import 'package:hablab/models/tags.dart';
import 'package:hablab/utils.dart';

final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late final ValueNotifier<List<AmountData>> _selectedEvents;
  final events = LinkedHashMap<DateTime, List<AmountData>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  AmountDataProvider provider = AmountDataProvider();
  DateTime date = DateTime(2022, 1, 1);
  static DateTime _focusedDay = DateTime.now();
  static DateTime _selectedDay = _focusedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<DropdownMenuItem<int>> _items = [
    for (var tag in Tags())
      DropdownMenuItem(value: tag.id, child: Text(tag.tag))
  ];

  @override
  void initState() {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

    Future.delayed(Duration.zero).then((_) => setEvents());

    super.initState();
  }

  Future<void> setEvents() async {
    // TODO: Dummy data.
    // 2022年のデータを取得する
    List<AmountData> data = await AmountDataProvider().get1Year(2022);
    // List<AmountData> data = await AmountDataProvider().get1Month(2022, 1);
    // data.addAll(await AmountDataProvider().get1Month(2022, 2));
    // data.addAll(await AmountDataProvider().get1Month(2022, 3));

    // データを日付毎にグルーピングする
    // List<AmountData> -> Map<AmountData.date, List<AmountData>>
    var groupingData = groupBy(data, (AmountData obj) => obj.date);

    // グルーピングしたデータをEvent()に格納
    groupingData.forEach(
      (key, value) {
        events.addAll(
          {
            key: List.generate(
                value.length,
                (index) => AmountData(value[index].id, key, value[index].tag,
                    value[index].amount))
          },
        );
      },
    );
  }

  // カレンダーで選択している日付に新しいデータを追加する
  void _addNewData() {
    int _selectItem = 0;
    double _inputItem = 0.0;
    showDialog(
      context: context,
      builder: (context) {
        final l10n = L10n.of(context)!;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(outputFormat.format(_selectedDay)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    items: _items,
                    value: _selectItem,
                    onChanged: (value) => {
                      setState(() {
                        _selectItem = int.parse(value.toString());
                      }),
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: l10n.inputAmount),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) => _inputItem = double.parse(value),
                  ),
                ],
              ),
              actions: <Widget>[
                // ボタン領域
                OutlinedButton(
                  child: Text(l10n.cancel),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text(l10n.save),
                  onPressed: () {
                    provider.insert(AmountData(
                        null, _selectedDay, _selectItem, _inputItem));
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 選択したデータを削除する
  void _deleteData(AmountData data) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = L10n.of(context)!;
        return AlertDialog(
          title: Text(l10n.deleteMessage),
          actions: <Widget>[
            // ボタン領域
            OutlinedButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(l10n.ok),
              onPressed: () {
                if (!data.id!.isNaN) {
                  provider.delete(data.id!);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('2'),
      ),
      body: Center(
        child: FutureBuilder(
          future: setEvents(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.error != null) {
              return Text(l10n.error);
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TableCalendar(
                  firstDay: DateTime.utc(2022, 1, 1),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                  },
                  eventLoader: _getEventsForDay,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<AmountData>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    onTap: () => print('${value[index]}'),
                                    title: Text('${value[index]}'),
                                  ),
                                ),
                                TextButton(
                                  child: Text(l10n.deleteButton),
                                  onPressed: () => _deleteData(value[index]),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewData,
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<AmountData> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
}
