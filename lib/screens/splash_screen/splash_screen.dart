import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trpo_app/screens/login_screen/login_student_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (xtx) => const LoginStudentScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 53, 56, 1),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/splash.png',
              //25% of height & 50% of width
              height: 325,
              width: 350,
            ),
          ],
        ),
      ),
    );
  }
}
