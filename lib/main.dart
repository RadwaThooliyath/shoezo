import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoezo/screens/home.dart';
import 'package:shoezo/screens/navig.dart';
import 'package:shoezo/screens/product.dart';
import 'package:shoezo/screens/provider.dart';
import 'package:shoezo/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDzIqCOJ9XD1tO2nSpfISEgRx8DIbHPvUE",
    authDomain: 'shoezo.firebaseapp.com',
    projectId: 'shoezo',
    storageBucket: "shoezo.appspot.com",
    messagingSenderId: '466254101789',
    appId: "1:466254101789:android:3c31b38559aeccca3ff5f4",
    //measurementId: '8041727286',
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
