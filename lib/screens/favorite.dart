import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff9daf9b), // Set the Scaffold background color
      appBar: AppBar(
        title: Text(
          "SHOEZO",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final favoriteItems = snapshot.data?.docs ?? [];

            if (favoriteItems.isEmpty) {
              return Center(
                child: Text(
                  "Your favorite is empty",
                  style: TextStyle(
                      fontSize: screenWidth * 0.05, color: Colors.black54),
                ),
              );
            }

            return ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item =
                favoriteItems[index].data() as Map<String, dynamic>;
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
                    subtitle: Text(
                      'Price: \$${item['price']?.toStringAsFixed(2) ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Color(0xff9daf9b)),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('favorites')
                            .doc(favoriteItems[index].id)
                            .delete();
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
