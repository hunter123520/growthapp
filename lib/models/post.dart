import 'dart:typed_data';

class Post {
  final String userName;
  final String text;
  final String? imagePath; // for mobile
  final Uint8List? imageBytes; // for web
  List<String> comments;
  int likes;

  Post({
    required this.userName,
    required this.text,
    this.imagePath,
    this.imageBytes,
    this.comments = const [],
    this.likes = 0,
  });
  void addComment(String comment) {
    comments = [...comments,comment];
  }
}
