import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../db.dart';

const String tableAmountData = 'amount_data';
const String columnId = 'id';
const String columnDate = 'date';
const String columnAmount = 'amount';

class AmountData {
  int? id;
  DateTime date;
  double amount;
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');

  AmountData(this.id, this.date, this.amount);

  String formatString() {
    return outputFormat.format(date) + " " + amount.toString();
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnDate: outputFormat.format(date),
      columnAmount: amount
    };
    return map;
  }
}

class AmountDataList {
  List<AmountData> list = [];
  AmountDataList();

  AmountData get(int index) {
    return list[index];
  }

  void add(AmountData data) {
    list.add(data);
  }

  void update(List<AmountData> data) {
    list = data;
  }
}

class AmountDataProvider {
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');

  AmountDataProvider();

  Future<AmountData> insert(AmountData amountData) async {
    Database db = await MyDatabase.get();
    amountData.id = await db.insert(tableAmountData, amountData.toMap());
    return amountData;
  }

  Future<List<AmountData>> get() async {
    Database db = await MyDatabase.get();
    List<Map> maps = await db.query(
      tableAmountData,
      columns: [columnId, columnDate, columnAmount],
    );
    if (maps.isNotEmpty) {
      return maps.map((Map m) {
        int id = m[columnId];
        DateTime date = DateTime.parse(m[columnDate]);
        double amount = m[columnAmount];
        return AmountData(id, date, amount);
      }).toList();
    }
    return [];
  }

  Future<AmountData?> findBy(int id) async {
    Database db = await MyDatabase.get();
    List<Map> maps = await db.query(tableAmountData,
        columns: [columnId, columnDate, columnAmount],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      Map m = maps.first;
      int id = m[columnId];
      DateTime date = m[columnDate];
      double amount = m[columnAmount];
      return AmountData(id, date, amount);
    }
    return null;
  }

  Future<List<AmountData>> get1Month(int year, int month) async {
    Database db = await MyDatabase.get();
    DateTime startDate = DateTime(year, month);
    DateTime endDate = DateTime(year, month + 1);
    List<Map> maps = await db.query(tableAmountData,
        columns: [columnId, columnDate, columnAmount],
        where: '? <= $columnDate AND $columnDate < ?',
        whereArgs: [
          outputFormat.format(startDate),
          outputFormat.format(endDate)
        ]);
    if (maps.isNotEmpty) {
      return maps.map((Map m) {
        int id = m[columnId];
        DateTime date = DateTime.parse(m[columnDate]);
        double amount = m[columnAmount];
        return AmountData(id, date, amount);
      }).toList();
    }
    return [];
  }

  // Future<List<AmountData>> where(DateTime? date) async {
  //   List<Map> maps = await db.query(tableAmountData,
  //       columns: [columnId, columnDate, columnAmount],
  //       where: '$columnDate = ?',
  //       whereArgs: [date]);
  //   if (maps.isNotEmpty) {
  //     return maps.map((Map m) {
  //       int id = m[columnId];
  //       DateTime date = m[columnDate];
  //       double amount = m[columnAmount];
  //       return AmountData(id, date, amount);
  //     }).toList();
  //   }
  //   return [];
  // }
}
