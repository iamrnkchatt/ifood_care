import 'package:donationapp/screens/home_screen.dart';
import 'package:donationapp/screens/onboarding_screen.dart';
import 'package:donationapp/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Size size = WidgetsBinding.instance!.window.physicalSize;
double width = size.width;
double height = size.height;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (auth.currentUser == null) {
          print('Login Screen Route');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              (route) => false);
        } else {
          // print('Doctor Screen Route');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        }
      },
    );
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.of(context)
    //       .pushAndRemoveUntil(_createRoute(), (route) => false);
    // });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 25, 55, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: width * 0.05,
              backgroundImage: const AssetImage("assets/images/logo.png"),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const OnboardingScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
