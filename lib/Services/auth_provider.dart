import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthClass {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  //Sign in with phone

  //Create Account
  Future<String> createUser(
      String email, String password, String name, String country) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      String userdoc = user!.uid;
      await FirebaseFirestore.instance.collection("Users").doc(userdoc).set({
        "email": email,
        "name": name,
        "country": country,
        "password": password,
      });
      var _fcmToken = fcm.getToken().then((value) {
        print(value);
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userdoc)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      print("User id: $user");

      return "Created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occurred";
    }
    return 'Information Required';
  }

  //Sign in user
  Future<String> signIN(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // final cred1 = await auth.signInWithPhoneNumber(phone);
      final user = credential.user;
      var _fcmToken = fcm.getToken().then((value) {
        print(value);
        FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .collection("TOKENS")
            .doc(value)
            .set({
          "token": value,
        });
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      print("User:$user");
      return "Welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    return 'Try Again';
  }

  //Reset Password
  Future<String> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return "Email sent";
    } catch (e) {
      return "Error occurred";
    }
  }

  //SignOut
  void logOut() async {
    auth.signOut();
  }
}
