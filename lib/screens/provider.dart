// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class CartProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _cartItems = [];
//
//   List<Map<String, dynamic>> get cartItems => _cartItems;
//
//   void addToCart(Map<String, dynamic> product) async {
//     final existingItemIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);
//
//     if (existingItemIndex >= 0) {
//       _cartItems[existingItemIndex]['quantity'] += 1;
//     } else {
//       final docRef = await FirebaseFirestore.instance.collection('cart').add(product);
//       _cartItems.add({
//         'id': docRef.id,
//         ...product,
//         'quantity': 1,
//       });
//     }
//     notifyListeners();
//   }
//
//   void removeFromCart(Map<String, dynamic> product) async {
//     try {
//       // Remove the item from Firestore
//       await FirebaseFirestore.instance.collection('cart').doc(product['id']).delete();
//
//       // Remove the item from the local list
//       _cartItems.removeWhere((item) => item['id'] == product['id']);
//       notifyListeners();
//     } catch (e) {
//       print("Error removing item from Firestore: $e");
//     }
//   }
// }
