import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';

class NewsDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final favoriteSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('title', isEqualTo: widget.newsItem['title'])
        .where('content', isEqualTo: widget.newsItem['content'])
        .get();

    setState(() {
      isFavorite = favoriteSnapshot.docs.isNotEmpty;
    });
  }

  Future<void> addToFavorites() async {
    await FirebaseFirestore.instance.collection('favorites').add({
      'title': widget.newsItem['title'],
      'content': widget.newsItem['content'],
      'imageUrl': widget.newsItem['imageUrl'] ?? '', // Asigna un valor predeterminado si es null
    });
    setState(() {
      isFavorite = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Favorites')),
    );
  }

  Future<void> removeFromFavorites() async {
    final favoriteSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('title', isEqualTo: widget.newsItem['title'])
        .where('content', isEqualTo: widget.newsItem['content'])
        .get();

    for (var doc in favoriteSnapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {
      isFavorite = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from Favorites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = widget.newsItem['imageUrl'] ?? ''; // Asigna un valor predeterminado si es null

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.newsItem['title']),
        backgroundColor: AppColors.darkBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl)
                : const Placeholder(fallbackHeight: 200), // Usa una imagen de marcador de posición
            const SizedBox(height: 16),
            Text(widget.newsItem['content'], style: const TextStyle(color: AppColors.teal)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isFavorite ? removeFromFavorites : addToFavorites,
              child: Text(isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
