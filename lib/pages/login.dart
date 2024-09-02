import 'package:expense_app/Animations/FadeAnimation.dart';
import 'package:expense_app/pages/register.dart';
import 'package:expense_app/user_auth/user_firebase_services/authentication.dart';
import 'package:expense_app/widgets/bottomnavigation.dart';
import 'package:expense_app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } else {
      showSnackBar(context, res);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 83, 53, 7),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
                1.2,
                const Text(
                  "Let's sign you in.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 30),
            FadeAnimation(
                1.5,
                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 83, 53, 7),
                      border: Border.all(color: Colors.white)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "Email"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                )),
                            hintText: "Password",
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: FadeAnimation(
                  1.6,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 6),
                      Text("Register",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeAnimation(
                1.8,
                Center(
                  child: MaterialButton(
                    onPressed: loginUser,
                    color: Color.fromARGB(170, 199, 193, 181),
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
