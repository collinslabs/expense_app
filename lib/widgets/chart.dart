import 'package:expense_app/content/model/add_data.dart';
import 'package:expense_app/content/utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final int indexx; // Use final since it's not mutable
  Chart({Key? key, required this.indexx}) : super(key: key); // Add the semicolon here

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<AddData>? a;
  bool b = true;
  bool j = true;

  @override
  Widget build(BuildContext context) {
    // Determine data based on indexx
    switch (widget.indexx) {
      case 0:
        a = today();
        b = true;
        j = true;
        break;
      case 1:
        a = week();
        b = false;
        j = true;
        break;
      case 2:
        a = month();
        b = false;
        j = true;
        break;
      case 3:
        a = year();
        j = false;
        break;
      default:
        a = [];
        break;
    }

    // Create SalesData list
    List<SalesData> salesDataList = List.generate(time(a!, b).length, (index) {
      final dateValue = j
          ? b
              ? a![index].dateTime.hour.toString()
              : a![index].dateTime.day.toString()
          : a![index].dateTime.month.toString();
      final salesValue = index > 0
          ? time(a!, b)[index] + time(a!, b)[index - 1]
          : time(a!, b)[index];

      return SalesData(salesValue, dateValue);
    });

    return Container(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<SalesData, String>>[
          SplineSeries<SalesData, String>(
            color: Color.fromARGB(255, 83, 53, 7),
            width: 3,
            dataSource: salesDataList,
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
          )
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
