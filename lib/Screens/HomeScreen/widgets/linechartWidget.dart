import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'dataSeries.dart';

class LineChatWidget extends StatelessWidget {
  final List<DataSeries> data;
  final bool animate;

  LineChatWidget(this.data, {this.animate});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DataSeries, num>> series = [
      charts.Series(
        id: "profits",
        data: data,
        domainFn: (DataSeries data, _) => data.year,
        measureFn: (DataSeries data, _) => data.developers,
        colorFn: (DataSeries data, _) => data.barColor,
      )
    ];
    return charts.LineChart(
      series,
      defaultRenderer:
          new charts.LineRendererConfig(includeArea: true, stacked: true),
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
        renderSpec: charts.GridlineRendererSpec(
         
          lineStyle: charts.LineStyleSpec(
            thickness: 0,
            // color: charts.Color.transparent   
          ),
          
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.fromHex(code: "FF8E8E8E"),
          ),
        ),
        // viewport: charts.NumericExtents(2016.0, 2022.0),
      ),
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredTickCount: 4,
          zeroBound: false,
        ),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(
            dashPattern: [4, 4],
            color: charts.Color.fromHex(code: "FF8E8E8E"),
          ),
          labelStyle: charts.TextStyleSpec(
            color: charts.Color.fromHex(code: "FF8E8E8E"),
          ),
        ),
      ),
    );
  }
}
