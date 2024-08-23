import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoezo/screens/cart.dart';
import 'package:shoezo/screens/product.dart';

class Girls extends StatefulWidget {
  const Girls({super.key});

  @override
  State<Girls> createState() => _GirlsState();
}

class _GirlsState extends State<Girls> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "SHOEZO",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xff9daf9b),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('product')
                    .where('category', isEqualTo: 'girl')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final products = snapshot.data?.docs ?? [];

                  if (products.isEmpty) {
                    return Center(child: Text('No products found.'));
                  }

                  return Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index, realIndex) {
                          final product = products[index];
                          final imageUrl = product['img'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Product(productId: product.id),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 500.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          scrollDirection: Axis.vertical,
                          onPageChanged: (index, reason) {
                            _currentIndexNotifier.value = index;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ValueListenableBuilder<int>(
                        valueListenable: _currentIndexNotifier,
                        builder: (context, currentIndex, _) {
                          final product = products[currentIndex];
                          final description = product['description'] ?? 'No description available';
                          final price = product['price']?.toStringAsFixed(2) ?? '0.00';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                              'Description: $description',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Price: \$${price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
