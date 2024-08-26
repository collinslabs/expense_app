import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 300,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <SplineSeries<SalesData, String>>[
            SplineSeries<SalesData, String>(
              color: const Color.fromARGB(255, 83, 53, 7),
              width: 3,
              dataSource: <SalesData>[
                SalesData(100, "mon"),
                SalesData(20, "tue"),
                SalesData(40, "wen"),
                SalesData(15, "sat"),
                SalesData(5, "sun"),
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
            ),
          ],
        ),
    );
  }
}

class SalesData {
  SalesData(this.sales, this.year);
  final int sales;
  final String year; 
}
