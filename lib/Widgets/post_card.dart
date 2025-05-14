import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import 'comment_section.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showComments = false;
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      widget.post.likes += isLiked ? 1 : -1;
    });
  }

  void _addComment(String comment) {
    setState(() {
      widget.post.addComment(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green[100],
                  child: const Icon(Icons.person, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2 hrs ago'.tr(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          if (post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post.text,
                style: const TextStyle(fontSize: 14),
              ),
            ),

          // SIZE NOT GOOD ( Sellami => UPDATE IT WHEN YOU HAVE TIME)
          if (post.imageBytes != null || post.imagePath != null)
  Padding(
    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
    child: AspectRatio(
      aspectRatio: 4.5/5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: post.imageBytes != null
              ? Image.memory(
                  post.imageBytes!, 
                  fit: BoxFit.cover, 
                )
              : Image.file(
                  File(post.imagePath!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    ),
  ),

          // Like and comment count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${post.likes}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${post.comments.length}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),

          // Action buttons
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _toggleLike,
                    style: TextButton.styleFrom(
                      foregroundColor: isLiked ? theme.primaryColor : Colors.grey[700],
                    ),
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      size: 18,
                    ),
                    label: Text(
                      'Like'.tr(),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => setState(() => showComments = !showComments),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    icon: const Icon(Icons.comment_outlined, size: 18),
                    label:  Text(
                      'Comment'.tr(),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label:  Text(
                      'Share'.tr(),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Comments section
          if (showComments)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: CommentPage(
                comments: post.comments,
                onAdd: _addComment,
              ),
            ),
        ],
      ),
    );
  }
}