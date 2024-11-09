import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import 'news_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.darkBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final favoritesList = snapshot.data!.docs;
          if (favoritesList.isEmpty) {
            return const Center(child: Text('No favorites added.'));
          }
          return ListView.builder(
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              final favoriteItem = favoritesList[index];
              return Card(
                color: AppColors.mint,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    favoriteItem['title'],
                    style: const TextStyle(color: AppColors.darkBlue),
                  ),
                  subtitle: Text(
                    favoriteItem['content'],
                    style: const TextStyle(color: AppColors.teal),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Eliminar el elemento de favoritos
                      await favoriteItem.reference.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Removed from Favorites')),
                      );
                    },
                  ),
                  onTap: () {
                    // Navegar a la pantalla de detalles con la opción de eliminar el favorito
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(newsItem: favoriteItem),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
