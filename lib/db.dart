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
  tag INTEGER,
  amount REAL
)
''');

      // TODO: Dummy data.
      DateTime date = DateTime(2022, 2, 1);
      DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 1, 'amount': 40});
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 2, 'amount': 20});
      date = date.add(const Duration(days: 1));
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 1, 'amount': 53});
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 2, 'amount': 23});
      date = date.add(const Duration(days: 1));
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 1, 'amount': 50});
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 2, 'amount': 20});
      date = date.add(const Duration(days: 1));
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 1, 'amount': 40});
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 2, 'amount': 20});
      date = date.add(const Duration(days: 1));
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 1, 'amount': 35});
      await db.insert('amount_data',
          {'date': outputFormat.format(date), 'tag': 2, 'amount': 25});
    });
  }
}
