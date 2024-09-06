import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff9daf9b), // Set the background color of the Scaffold
      appBar: AppBar(
        title: Text(
          "SHOEZO",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid) // Query by the user's ID
              .collection('cart')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final cartItems = snapshot.data?.docs ?? [];

            if (cartItems.isEmpty) {
              return Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.black54),
                ),
              );
            }

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(screenWidth * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['img'] ?? '',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                      ),
                    ),
                    title: Text(
                      item['description'] ?? 'No description available',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity: ${item['quantity'] ?? 1}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Color(0xff9daf9b)),
                          onPressed: () async {
                            final currentQuantity = item['quantity'] ?? 1;
                            if (currentQuantity > 1) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('cart')
                                  .doc(cartItems[index].id)
                                  .update({'quantity': currentQuantity - 1});
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('cart')
                                  .doc(cartItems[index].id)
                                  .delete();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Color(0xff9daf9b)),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('cart')
                                .doc(cartItems[index].id)
                                .delete();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Color(0xff9daf9b)),
                          onPressed: () async {
                            final currentQuantity = item['quantity'] ?? 1;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('cart')
                                .doc(cartItems[index].id)
                                .update({'quantity': currentQuantity + 1});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )

      ),
    );
  }
}
