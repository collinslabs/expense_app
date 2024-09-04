import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinancialGoalsPage extends StatefulWidget {
  @override
  _FinancialGoalsPageState createState() => _FinancialGoalsPageState();
}

class _FinancialGoalsPageState extends State<FinancialGoalsPage> {
  double currentAmount = 2000.0;
  double goalAmount = 5000.0;
  String goalName = "Save for Vacation";
  List<String> tips = [
    "Reduce dining out expenses.",
    "Sell unused items to generate extra income.",
    "Automate savings to your goal."
  ];

  @override
  Widget build(BuildContext context) {
    double progress = currentAmount / goalAmount;
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(212, 222, 230, 1),
      appBar: AppBar(  backgroundColor: Color.fromRGBO(212, 222, 230, 1),
        title: Text(    "Financial Goals",
            style: TextStyle(     
               color: Color.fromARGB(255, 83, 53, 7), 
                fontSize: 24, 
                fontWeight: FontWeight.w800,    ),
                textAlign: TextAlign.center,  ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                 ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Goal: $goalName",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              SizedBox(height: 10),
              Text(
                "\KES ${currentAmount.toStringAsFixed(2)} / \KES ${goalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                "Tips to reach your goal:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.lightbulb_outline),
                    title: Text(tips[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditTipDialog(context, index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              tips.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showUpdateGoalSheet(context);
                },
                child: Text("Update Goal"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 83, 53, 7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showAddTipDialog(context);
                },
                child: Text("Add Tip",),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 83, 53, 7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 void _showUpdateGoalSheet(BuildContext context) {
  TextEditingController goalNameController =
      TextEditingController(text: goalName);
  TextEditingController goalAmountController =
      TextEditingController(text: goalAmount.toString());
  TextEditingController currentAmountController =
      TextEditingController(text: currentAmount.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Update Goal",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: goalNameController,
                    decoration: InputDecoration(labelText: "Goal Name"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: goalAmountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(labelText: "Goal Amount (\KES)"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: currentAmountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(labelText: "Current Amount (\KES)"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        goalName = goalNameController.text;
                        goalAmount = double.tryParse(goalAmountController.text) ?? goalAmount;
                        currentAmount = double.tryParse(currentAmountController.text) ?? currentAmount;
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 83, 53, 7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}



  void _showAddTipDialog(BuildContext context) {
    TextEditingController tipController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Tip"),
          content: TextFormField(
            controller: tipController,
            decoration: InputDecoration(labelText: "Tip"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tips.add(tipController.text);
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
              style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 83, 53, 7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }

  void _showEditTipDialog(BuildContext context, int index) {
    TextEditingController tipController = TextEditingController(text: tips[index]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Tip"),
          content: TextFormField(
            controller: tipController,
            decoration: InputDecoration(labelText: "Tip"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tips[index] = tipController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
