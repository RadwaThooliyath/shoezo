import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoezo/screens/account.dart';
import 'package:shoezo/screens/cart.dart';
import 'package:shoezo/screens/favorite.dart';
import 'package:shoezo/screens/girls.dart';
import 'package:shoezo/screens/boys.dart';
import 'package:shoezo/screens/home.dart';

class Navig extends StatefulWidget {
  const Navig({super.key});

  @override
  State<Navig> createState() => _NavigState();
}

class _NavigState extends State<Navig> {
  int selectedIndex = 0;

  List<Map<String, dynamic>> cartItems = [];

  List<Widget> pages() {
    return [
      Home(),
      Favorite(),
      Cart(),
      Account(),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages()[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_solid),
            label: 'Favorites',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle_fill),
            label: 'Account',
            backgroundColor: Colors.white,
          ),
        ],
        selectedItemColor: Color(0xff9daf9b),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
      ),
    );
  }
}
