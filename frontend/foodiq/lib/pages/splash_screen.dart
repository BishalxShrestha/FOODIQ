import 'dart:async';
import 'package:flutter/material.dart';

import 'package:foodiq/pages/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => WelcomePage()),
  );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image.asset("assets/images/splashicon.png"),

              const CircularProgressIndicator(
            color: Colors.blueAccent, // Matches theme color
            strokeWidth: 4,
          ),
          
          ],
        ),
      ),
    );
  }
}
