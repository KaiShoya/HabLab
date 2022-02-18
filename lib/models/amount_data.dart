import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../db.dart';

const String tableAmountData = 'amount_data';
const String columnId = 'id';
const String columnDate = 'date';
const String columnTag = 'tag';
const String columnAmount = 'amount';

class AmountData {
  final int? id;
  final DateTime date;
  final int tag;
  final double amount;
  static final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

  AmountData(this.id, this.date, this.tag, this.amount);

  String formatString() {
    return outputFormat.format(date) +
        " " +
        tag.toString() +
        " " +
        amount.toString();
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnDate: outputFormat.format(date),
      columnTag: tag,
      columnAmount: amount
    };
    return map;
  }

  @override
  String toString() => tag.toString() + " " + amount.toString();
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
    await db.insert(tableAmountData, amountData.toMap());
    return amountData;
  }

  Future<List<AmountData>> get() async {
    Database db = await MyDatabase.get();
    List<Map> maps = await db.query(
      tableAmountData,
      columns: [columnId, columnDate, columnTag, columnAmount],
    );
    if (maps.isNotEmpty) {
      return maps.map((Map m) {
        int id = m[columnId];
        DateTime date = DateTime.parse(m[columnDate]);
        double amount = m[columnAmount];
        return AmountData(id, date, m[columnTag], amount);
      }).toList();
    }
    return [];
  }

  Future<AmountData?> findByDate(DateTime date) async {
    Database db = await MyDatabase.get();
    List<Map> maps = await db.query(tableAmountData,
        columns: [columnId, columnDate, columnTag, columnAmount],
        where: '$columnDate = ?',
        whereArgs: [date]);
    if (maps.isNotEmpty) {
      Map m = maps.first;
      int id = m[columnId];
      DateTime date = m[columnDate];
      double amount = m[columnAmount];
      return AmountData(id, date, m[columnTag], amount);
    }
    return null;
  }

  Future<List<AmountData>> get1Year(int year) async {
    Database db = await MyDatabase.get();
    DateTime startDate = DateTime(year);
    DateTime endDate = DateTime(year + 1);
    List<Map> maps = await db.query(tableAmountData,
        columns: [columnId, columnDate, columnTag, columnAmount],
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
        return AmountData(id, date, m[columnTag], amount);
      }).toList();
    }
    return [];
  }

  Future<List<AmountData>> get1Month(int year, int month) async {
    Database db = await MyDatabase.get();
    DateTime startDate = DateTime(year, month);
    DateTime endDate = DateTime(year, month + 1);
    List<Map> maps = await db.query(tableAmountData,
        columns: [columnId, columnDate, columnTag, columnAmount],
        // TODO: Dummy data. tag = 1
        where: '$columnTag = 1 AND ? <= $columnDate AND $columnDate < ?',
        whereArgs: [
          outputFormat.format(startDate),
          outputFormat.format(endDate)
        ]);
    if (maps.isNotEmpty) {
      return maps.map((Map m) {
        int id = m[columnId];
        DateTime date = DateTime.parse(m[columnDate]);
        double amount = m[columnAmount];
        return AmountData(id, date, m[columnTag], amount);
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

  Future<bool> delete(int id) async {
    Database db = await MyDatabase.get();
    int count = await db
        .delete(tableAmountData, where: '$columnId = ?', whereArgs: [id]);
    return count >= 0;
  }
}
