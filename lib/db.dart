import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static const String path = 'hablab.db';

  static Future<Database> get() async {
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
CREATE TABLE amount_data (
  id INTEGER PRIMARY KEY,
  date TEXT,
  amount REAL
)
''');

      // TODO: Dummy data.
      DateTime date = DateTime(2022, 1, 1);
      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      await db.insert(
          'amount_data', {'date': outputFormat.format(date), 'amount': 40});
      date = date.add(const Duration(days: 1));
      await db.insert(
          'amount_data', {'date': outputFormat.format(date), 'amount': 53});
      date = date.add(const Duration(days: 1));
      await db.insert(
          'amount_data', {'date': outputFormat.format(date), 'amount': 50});
      date = date.add(const Duration(days: 1));
      await db.insert(
          'amount_data', {'date': outputFormat.format(date), 'amount': 40});
      date = date.add(const Duration(days: 1));
      await db.insert(
          'amount_data', {'date': outputFormat.format(date), 'amount': 35});
    });
  }
}
