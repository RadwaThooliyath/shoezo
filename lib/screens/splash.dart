import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shoezo/screens/login.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
       child: Image.asset("assets/splash.png",),
     ),
    );
  }
}
