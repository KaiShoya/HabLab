import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/amount_data.dart';
import '../utils.dart';

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

  @override
  void initState() {
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

    Future.delayed(Duration.zero).then((_) => setEvents());

    super.initState();
  }

  Future<void> setEvents() async {
    // 2022年のデータを取得する
    List<AmountData> data = await AmountDataProvider().get1Year(2022);

    // データを日付毎にグルーピングする
    // List<AmountData> -> Map<AmountData.date, List<AmountData>>
    var groupingData = groupBy(data, (AmountData obj) => obj.date);

    // グルーピングしたデータをEvent()に格納
    groupingData.forEach((key, value) {
      events.addAll({
        key: List.generate(value.length,
            (index) => AmountData(key, value[index].tag, value[index].amount))
      });
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2'),
      ),
      body: Center(
        child: FutureBuilder(
          future: setEvents(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.error != null) {
              return const Text('エラーが発生しました');
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
                            child: ListTile(
                              onTap: () => print('${value[index]}'),
                              title: Text('${value[index]}'),
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
    );
  }

  List<AmountData> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
}
