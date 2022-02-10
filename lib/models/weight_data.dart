import 'package:intl/intl.dart';

const String tableWeightData = 'weight_data';
const String columnId = 'id';
const String columnDate = 'date';
const String columnWeight = 'weight';

class WeightData {
  int? id;
  DateTime date;
  double weight;

  WeightData(this.id, this.date, this.weight);

  String formatString() {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.format(date) + " " + weight.toString();
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{columnDate: date, columnWeight: weight};
    return map;
  }
}

class WeightDataList {
  List<WeightData> list = [];
  WeightDataList();

  void add(WeightData data) {
    list.add(data);
  }
}


  WeightData(this.date, this.weight);
}
