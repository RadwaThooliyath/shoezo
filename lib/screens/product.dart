import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product extends StatefulWidget {
  final String productId;

  const Product({required this.productId, super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int _quantity = 1;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(String productId, String productName, double productPrice, String productDescription, String productImage, int quantity) async {
    if (user == null) return; // Ensure the user is logged in

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid) // Use the user's ID as the document reference
        .collection('cart');

    final cartItem = await cartRef.doc(productId).get();

    if (cartItem.exists) {
      await cartRef.doc(productId).update({
        'quantity': FieldValue.increment(quantity),
      });
    } else {
      await cartRef.doc(productId).set({
        'productId': productId,
        'name': productName,
        'price': productPrice,
        'description': productDescription,
        'img': productImage,
        'quantity': quantity,
        'userId': user!.uid, // Add the user ID to the document
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $quantity item(s) to cart')),
    );
  }


  Future<void> addToFavorites(String productId, String productName, double productPrice, String productDescription, String productImage) async {
    if (user == null) return; // Ensure the user is logged in

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid) // Use the user's ID as the document reference
        .collection('favorites');

    // Check if the product is already in the favorites
    final favoriteItem = await favoritesRef.doc(productId).get();

    if (favoriteItem.exists) {
      // Optionally, you can show a message that the item is already in the favorites
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item is already in Favorites')),
      );
    } else {
      // Add the product to the favorites collection
      await favoritesRef.doc(productId).set({
        'productId': productId,
        'name': productName,
        'price': productPrice,
        'description': productDescription,
        'img': productImage,
        'userId': user!.uid, // Add the user ID to the document
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to Favorites')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        backgroundColor: Color(0xff9daf9b),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('product')
            .doc(widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String productName = data['name'] ?? 'Product Name';
          final String productDescription = data['description'] ?? 'This is a detailed description of the product.';
          final double productPrice = data['price']?.toDouble() ?? 0.0;
          final String productImage = data['img'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    productImage,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Description: $productDescription",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  "Price: \$$productPrice",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Quantity:",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) _quantity--;
                            });
                          },
                        ),
                        Text(
                          _quantity.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 90),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addToCart(widget.productId, productName, productPrice, productDescription, productImage, _quantity);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff9daf9b),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addToFavorites(widget.productId, productName, productPrice, productDescription, productImage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff9daf9b),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Add to Favorites",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
