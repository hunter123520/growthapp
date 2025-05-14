import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewPostWidget extends StatefulWidget {
  final Function(String, dynamic) onPost;

  const NewPostWidget({required this.onPost, super.key});

  @override
  State<NewPostWidget> createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> {
  final TextEditingController _controller = TextEditingController();
  Uint8List? _webImage;
  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() => _webImage = bytes);
      } else {
        setState(() => _imagePath = picked.path);
      }
    }
  }

  void _removeImage() {
    setState(() {
      _webImage = null;
      _imagePath = null;
    });
  }

  void _submitPost() {
    if (_controller.text.isEmpty && _webImage == null && _imagePath == null) return;
    
    widget.onPost(_controller.text, (kIsWeb ? _webImage : _imagePath));
    
    _controller.clear();
    setState(() {
      _webImage = null;
      _imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Create Post".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            
            // Text input field
            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "What's happening with your crops?".tr(),
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              style: const TextStyle(fontSize: 15),
            ),
            
            // Image preview
            if (_webImage != null || _imagePath != null)
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: kIsWeb && _webImage != null
                        ? Image.memory(_webImage!, fit: BoxFit.cover)
                        : _imagePath != null
                            ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                            : null,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: _removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Bottom action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add image button
                TextButton.icon(
                  onPressed: _pickImage,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.image_outlined, size: 20),
                  label:  Text(
                    "Photo".tr(),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                
                // Post button
                ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child:  Text(
                    "Post".tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}