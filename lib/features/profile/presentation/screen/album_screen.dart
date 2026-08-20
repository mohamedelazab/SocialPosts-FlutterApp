import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loader.dart';
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
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.albumTitle, overflow: TextOverflow.ellipsis)),
      body: FutureBuilder<List<PhotoModel>>(
        future: _photosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasError) {
            return AppError(
              message: "${snapshot.error}",
              onRetry: () =>
                  setState(() => _photosFuture = _usersApi.getAlbumPhotos(widget.albumId)),
            );
          }

          final photos = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "${photos.length} photos",
                    style: TextStyle(
                      color: semantic.inkDim,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final photo = photos[index];

                      return GestureDetector(
                        onTap: () => context.push(
                          '/album/${widget.albumId}/photo',
                          extra: {'photos': photos, 'initialIndex': index},
                        ),
                        child: Hero(
                          tag: 'photo-${photo.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _NetworkThumb(url: photo.thumbnailUrl),
                          ),
                        ),
                      );
                    },
                    childCount: photos.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NetworkThumb extends StatelessWidget {
  final String url;

  const _NetworkThumb({required this.url});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: semantic.surface2);
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: semantic.surface2,
        alignment: Alignment.center,
        child: Icon(Icons.image_not_supported_outlined, size: 18, color: semantic.inkDim),
      ),
    );
  }
}
