import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/new_post_widget.dart';
import '../widgets/post_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Post> posts = [];

  void _addPost(String text, dynamic image) {
   
  setState(() {
    posts.insert(
      0,
      Post(
        userName: "User".tr(),
        text: text,
        imageBytes: kIsWeb ? image as Uint8List? : null,
        imagePath: kIsWeb ? null : image as String?,
      ),
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Custom AppBar-style container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
     Flexible(
      child: Center(child: Text(
        "Community".tr(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),)
    ),
  ],
)

          ),
          const SizedBox(height: 8),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
        child: Column(
          children: [
            NewPostWidget(onPost: _addPost),
            ...posts.map((p) => PostCard(post: p)).toList(),
          ],
        ),
      ),
          ),
        ],
      ),
    );
    
  }
}
