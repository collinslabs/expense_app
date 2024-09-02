import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:expense_app/content/model/add_data.dart';

class FullHistory extends StatelessWidget {
  final Box<AddData> box;

  const FullHistory({Key? key, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(212, 222, 230, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 53, 7),
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('All Transactions',
        style: TextStyle(
          color: Colors.white
        ),
        ),
      ),
      body: ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, index) {
          final history = box.getAt(index);
          return ListTile(
            title: Text(history!.name),
            subtitle: Text(
                '${history.dateTime.year}-${history.dateTime.month}-${history.dateTime.day}'),
            trailing: Text(
              history.amount,
              style: TextStyle(
                color: history.IN == 'Income' ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
