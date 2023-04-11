import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class DataSeries {
  final int year;
  final int developers;
  final charts.Color barColor;

  DataSeries(
    {
      @required this.year,
      @required this.developers,
      @required this.barColor
    }
  );
}