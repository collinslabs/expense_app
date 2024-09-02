import 'package:expense_app/user_auth/user_firebase_services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  late Future<Map<String, dynamic>?> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await AuthServices().getUserData(user.uid);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(212, 222, 230, 1),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No user data available'));
            }

            final userData = snapshot.data!;
            return ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 220.0,
                      color: Color.fromRGBO(212, 222, 230, 1),
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    'PROFILE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Stack(fit: StackFit.loose, children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: ExactAssetImage('images/as.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Color.fromARGB(255, 83, 53, 7),
                                      radius: 25.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            _buildTextField("Full Name", userData['name']),
                            _buildTextField("Email", userData['email']),
                            _buildTextField("Password", "********"), // Avoid showing the actual password

                            !_status ? _getActionButtons() : Container(),
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                child: ElevatedButton(
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: ElevatedButton(
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _status = true;
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 83, 53, 7),
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _buildTextField(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: TextField(
              decoration: InputDecoration(hintText: value),
              enabled: !_status,
              obscureText: label == "Password" && _status == false, // Show password input type
            ),
          ),
        ],
      ),
    );
  }
}
