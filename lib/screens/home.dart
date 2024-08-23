import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:shoezo/screens/account.dart';
import 'package:shoezo/screens/boys.dart';
import 'package:shoezo/screens/cart.dart';
import 'package:shoezo/screens/girls.dart';
import 'package:shoezo/screens/navig.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchQuery = '';
  bool showText = false;
  late Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    // Determine the screen orientation
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xff9daf9b), // Set background color of Scaffold
      appBar: AppBar(
        backgroundColor: Color(0xff9daf9b),
        actions: [Icon(Icons.notifications)],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff9daf9b),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Navig()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Account()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Girls()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                        ),
                        child: Text("For Her",style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold),),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Boys()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                        ),
                        child: Text("For Him",style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5), // Adjust the padding as needed
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 550,
                          color: Color(0xff9daf9b),
                          //child: Lottie.asset('assets/delivery.json'),
                        ),
                        Positioned(
                          child: Text(
                            'Free Shipping on All Orders',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              // backgroundColor: Colors.white.withOpacity(0.6), // Background color with opacity
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Lottie.asset('assets/delivery.json')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Offers',
                      style: TextStyle(
                        fontSize: 22, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.black, // Set the text color
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('offers')
                          .where('size', isEqualTo: 'big')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final bigProducts = snapshot.data?.docs ?? [];

                        if (bigProducts.isEmpty) {
                          return Center(child: Text('No big products found.'));
                        }

                        return CarouselSlider(
                          options: CarouselOptions(
                            height: isPortrait ? 250 : 200,
                            autoPlay: true,
                            aspectRatio: isPortrait ? 16 / 9 : 16 / 7,
                            viewportFraction: 1.0,
                          ),
                          items: bigProducts.map((doc) {
                            final imgUrl = doc['img'];
                            //final offerText = (doc['offer'] ?? 'No Offer') + ' off'; // Adding " off" to the offer text

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(imgUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Implement navigation or action here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff9daf9b),
                                      ),
                                      child: Text(
                                        'Shop Now',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: isPortrait ? 20 : 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                    child: Text(
                      'Budget Buys',
                      style: TextStyle(
                        fontSize: 22, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.black, // Set the text color
                      ),
                    ),
                  ),
                  // Horizontal Containers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('offers')
                          .where('size', isEqualTo: 'small')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final smallImages = snapshot.data?.docs ?? [];

                        if (smallImages.isEmpty) {
                          return Center(child: Text('No small images found.'));
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: smallImages.map((doc) {
                              final imgUrl = doc['img'];
                              final offerText = doc['offer']; // Assuming 'offer' field is part of the smallImages data

                              return Container(
                                height: 140,
                                width: 150, // Adjust the width as needed
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        imgUrl,
                                        height: 140, // Adjust height as needed
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.black54, Colors.transparent],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          child: Text(
                                            offerText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: isPortrait ? 20 : 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                    child: Text(
                      'Deals of the day',
                      style: TextStyle(
                        fontSize: 22, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.black, // Set the text color
                      ),
                    ),
                  ),
                  // Horizontal Containers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('offers')
                          .where('size', isEqualTo: 'mid')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final smallImages = snapshot.data?.docs ?? [];

                        if (smallImages.isEmpty) {
                          return Center(child: Text('No small images found.'));
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: smallImages.map((doc) {
                              final imgUrl = doc['img'];
                              final offerText = doc['offer']; // Assuming 'offer' field is part of the smallImages data

                              return Container(
                                height: 140,
                                width: 150, // Adjust the width as needed
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        imgUrl,
                                        height: 140, // Adjust height as needed
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: 150,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.black54, Colors.transparent],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          child: Text(
                                            offerText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
