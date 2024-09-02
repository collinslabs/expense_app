import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Register user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user to Cloud Firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
        });

        print(
            "User data successfully written to Firestore for UID: ${credential.user!.uid}");
        res = "success"; // Set response to "success"
      } else {
        res = "Please fill in all fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        res = "The email address is already in use by another account.";
      } else {
        res = e.message ?? "An unknown error occurred.";
      }
      print(e.toString());
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res;
  }
  // login

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please enter all fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      } else {
        res = e.message ?? 'An unknown error occurred.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

 
Future<Map<String, dynamic>?> getUserData(String uid) async {
  try {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

}
