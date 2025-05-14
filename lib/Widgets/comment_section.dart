import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final List<String> comments;
  final Function(String) onAdd;

  const CommentPage({required this.comments, required this.onAdd, super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isWriting = false;

  void _submit() {
    if (_commentController.text.trim().isEmpty) return;
    
    widget.onAdd(_commentController.text.trim());
    _commentController.clear();
    setState(() => _isWriting = false);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Comments list
        if (widget.comments.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.comments.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.green[100],
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Farmer'.tr() +  '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.comments[index],
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No comments yet'.tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        // Add comment input
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green[100],
                child: Icon(Icons.person, size: 18, color: theme.primaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _commentController,
                    onChanged: (text) {
                      setState(() => _isWriting = text.trim().isNotEmpty);
                    },
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: "Write a comment...".tr(),
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                      suffixIcon: _isWriting
                          ? IconButton(
                              icon: Icon(Icons.send, 
                                size: 20,
                                color: theme.primaryColor,
                              ),
                              onPressed: _submit,
                            )
                          : null,
                    ),
                    style: const TextStyle(fontSize: 13),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}