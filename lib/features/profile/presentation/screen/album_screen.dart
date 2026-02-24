import 'package:flutter/material.dart';

import '../../../users/data/users_api.dart';
import '../../data/models/photo_model.dart';

class AlbumScreen extends StatefulWidget {
  final int albumId;
  final String albumTitle;

  const AlbumScreen({
    super.key,
    required this.albumId,
    required this.albumTitle,
  });

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final UsersApi _usersApi = UsersApi();
  late Future<List<PhotoModel>> _photosFuture;

  @override
  void initState() {
    super.initState();
    _photosFuture = _usersApi.getAlbumPhotos(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.albumTitle)),
      body: FutureBuilder<List<PhotoModel>>(
        future: _photosFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final photos = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];

              return GestureDetector(
                onTap: () {
                  // Optional: show full-screen photo
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Image.network(photo.url, fit: BoxFit.cover),
                    ),
                  );
                },
                child: Hero(
                  tag: photo.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(photo.thumbnailUrl, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
