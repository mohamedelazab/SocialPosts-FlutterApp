class PhotoModel {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  PhotoModel({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;

    return PhotoModel(
      albumId: json['albumId'],
      id: id,
      title: json['title'],
      // JSONPlaceholder's own url/thumbnailUrl point at via.placeholder.com,
      // which is defunct — seed picsum.photos with the id instead so each
      // photo still resolves to a stable, real image.
      url: "https://picsum.photos/seed/$id/600/600",
      thumbnailUrl: "https://picsum.photos/seed/$id/150/150",
    );
  }
}