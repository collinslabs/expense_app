import 'package:expense_app/pages/home.dart';
import 'package:expense_app/pages/statistics.dart';
import 'package:expense_app/widgets/bottomnavigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      //home: const Home(),
       //home: const Statistics(),
       home: const BottomNav(),
    );
  }
}


