import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:growth/data/disease_data.dart';
import 'package:image/image.dart' as img; // Add the image package
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:growth/Widgets/FeedBack.dart';
class MultiDetectionPage extends StatefulWidget {
  @override
  _MultiDetectionPageState createState() => _MultiDetectionPageState();
}

class _MultiDetectionPageState extends State<MultiDetectionPage> {
  File? _image;
  bool _isLoading = false;
  List<Map<String, dynamic>> _results = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
        _results = [];
      });

      final results = await predictMultipleLeaves(pickedFile);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  // Function to crop the image based on the bounding box
 Future<img.Image> cropImage(XFile imageFile, Map<String, dynamic> box) async {
  try {
    // Read bytes directly from XFile
    Uint8List bytes = await imageFile.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Failed to decode image.");

    // Handle both box formats: {x, y, width, height} or {x1, y1, x2, y2}
    int x = (box['x'] ?? box['x1']).toInt();
    int y = (box['y'] ?? box['y1']).toInt();
    int width = (box.containsKey('width') && box['width'] != null)
        ? box['width'].toInt()
        : ((box['x2'] ?? 0) - x).toInt();
    int height = (box.containsKey('height') && box['height'] != null)
        ? box['height'].toInt()
        : ((box['y2'] ?? 0) - y).toInt();

    // Clamp values to prevent errors
    x = x.clamp(0, image.width - 1);
    y = y.clamp(0, image.height - 1);
    width = width.clamp(1, image.width - x);
    height = height.clamp(1, image.height - y);

    return img.copyCrop(image, x, y, width, height);
  } catch (e) {
    print("Crop error: $e");
    rethrow;
  }
}


  
Future<List<Map<String, dynamic>>> predictMultipleLeaves(XFile imageFile) async {
  try {
    final url = Uri.parse("https://missingbreath-growth.hf.space/multiclassify");

    // Convert the image to bytes
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Compress the image
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: 800,      // Resize to a reasonable width
        minHeight: 800,     // Resize to a reasonable height
        quality: 70,        // Adjust quality (0 - worst, 100 - best)
        format: CompressFormat.jpeg,
      );

    // Create a POST request with the image file
    var request = http.MultipartRequest('POST', url);
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        compressedBytes,
        filename: 'multi_leaf.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    // Send the request and await the response
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    // Decode the JSON response
    var decoded = json.decode(responseBody);

    if (decoded['output'] == null || decoded['output'] is! List) {
      throw Exception("Response structure is unexpected.");
    }

    // Initialize a list to store the parsed results
    List<Map<String, dynamic>> parsedResults = [];

    for (var entry in decoded['output']) {
      
      var box = entry['box'];
      double confidence = entry['confidence'];
      int predictedClass = entry['predicted_class'];

      // Convert x1, y1, x2, y2 to x, y, width, height
      int x = box['x1'].toInt();
      int y = box['y1'].toInt();
      int width = (box['x2'] - box['x1']).toInt();
      int height = (box['y2'] - box['y1']).toInt();

      Map<String, dynamic> normalizedBox = {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

      // Get the disease name from the predicted class
      String diseaseName = diseaseClassNames[predictedClass];
      
      // Convert XFile to File
      // File fileImage = File(imageFile.path);
      img.Image croppedImage = await cropImage(imageFile, box); 
      // Crop the image
      // img.Image croppedImage = await cropImage(fileImage, normalizedBox);

      // Convert cropped image to base64
      Uint8List croppedImageBytes = Uint8List.fromList(img.encodeJpg(croppedImage));
      String base64CroppedImage = base64Encode(croppedImageBytes);

      // Add to results
      parsedResults.add({
        'box': normalizedBox,
        'confidence': confidence,
        'predictedClass': predictedClass,
        'disease': diseaseName,
        'leafImage': base64CroppedImage,
      });
    }

    return parsedResults;
  } catch (e) {
    print("Error: $e");
    return [];
  }
}

 String TextTransform(String str){
        return str.tr();
      }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null)
              Container(
                height: 200,
                child: kIsWeb
                    ? Image.network(_image!.path)
                    : Image.file(File(_image!.path)),
              ),
            _image != null?SizedBox(height: 20):SizedBox(height: 175),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () => _pickImage(ImageSource.camera),
              icon: Icon(Icons.camera_alt),
              label: Text("Take Picture".tr()),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
              icon: Icon(Icons.photo_library),
              label: Text("Choose from Gallery".tr()),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Processing multiple leaves...".tr()),
                  ],
                ),
              )
            else if (_results.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];
                  final imageBytes = base64Decode(item['leafImage']);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                TextTransform(item['disease']),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text("Confidence:".tr()+" ${(item['confidence'] * 100).toStringAsFixed(2)}%"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
          ],
        ),
      ),
    );
  }
}
