import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/user_auth/user_firebase_services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_app/content/model/add_data.dart';
import 'package:expense_app/content/listdata.dart';
import 'package:expense_app/content/utility.dart';
import 'package:expense_app/pages/full_history.dart';
import 'package:expense_app/pages/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<AddData> box;
  final List<String> day = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  User? user; // To store the logged-in user
  String? userName; // To store the user's name

  @override
  void initState() {
    super.initState();
    openBox();
    fetchUserInfo();
  }

  Future<void> openBox() async {
    box = await Hive.openBox<AddData>('data');
    setState(() {});
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final authServices = AuthServices();
      final userData = await authServices.getUserData(user.uid);
      setState(() {
        this.user = user;
        userName = userData?['name'];
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('data')) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212, 222, 230, 1),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 340, child: _header()),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transactions History',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (box.length > 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullHistory(box: box),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'See all',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color.fromARGB(255, 70, 43, 3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final history = box.getAt(index);
                      return getList(history!, index);
                    },
                    childCount: box.length > 5 ? 5 : box.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getList(AddData history, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        history.delete();
      },
      child: get(index, history),
    );
  }

  ListTile get(int index, AddData history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          'images/${geter()[index].image!}',
          height: 40,
          width: 40,
        ),
      ),
      title: Text(
        history.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        '${day[history.dateTime.weekday - 1]} ${history.dateTime.year}-${history.dateTime.month.toString().padLeft(2, '0')}-${history.dateTime.day.toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        history.amount,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: history.IN == 'Income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _header() {
    final greeting = _getGreeting();
    final displayName = userName ?? 'User'; // Fallback to 'User' if no name

    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 70, 43, 3),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Stack(
                children: [
                  Positioned(
                      top: 35,
                      left: 280,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.white,
                          child: const Icon(
                            Icons.notification_add_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 70, 43, 3),
                          ),
                        ),
                      )),
                  Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.white,
                          child: const Icon(
                            Icons.power_settings_new,
                            size: 30,
                            color: Color.fromARGB(255, 70, 43, 3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        Text(
                          displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 83, 53, 7),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 83, 53, 7),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  )
                ]),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.more_horiz,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\KES ${total()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Expenses',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.more_horiz,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\KES ${totalExpenses()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double total() {
    double total = 0;
    for (var item in box.values) {
      if (item.IN == 'Income') {
        total += double.parse(item.amount);
      } else {
        total -= double.parse(item.amount);
      }
    }
    return total;
  }

  double totalExpenses() {
    double total = 0;
    for (var item in box.values) {
      if (item.IN == 'Expense') {
        total += double.parse(item.amount);
      }
    }
    return total;
  }
}
