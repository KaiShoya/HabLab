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
  static final AmountDataList _amountList = AmountDataList();
  AmountDataProvider provider = AmountDataProvider();
  DateTime date = DateTime(2022, 1, 1);
  static DateTime _selectedDay = DateTime.now();
  static DateTime _focusedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  _Page2State() {
    provider.get1Month(2022, 1).then((data) => _amountList.update(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2'),
      ),
      body: Center(
        child: Column(
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
              },
              eventLoader: _getEventsForDay,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            // Expanded(child: ListViewAmountDataWidget(items: _amountList)),
          ],
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }
}
