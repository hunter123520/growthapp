import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:growth/data/disease_data.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:growth/widgets/gemini_chat_bot.dart';

class SingleDetectionPage extends StatefulWidget {
  @override
  _SingleDetectionPageState createState() => _SingleDetectionPageState();
}

class _SingleDetectionPageState extends State<SingleDetectionPage> {
  File? _image;
  Map<String, dynamic>? _result;
  bool _isLoading = false;

  final _scrollController = ScrollController();

final _descriptionKey = GlobalKey();
final _causesKey = GlobalKey();
final _effectsKey = GlobalKey();
final _treatmentKey = GlobalKey();
final _preventionKey = GlobalKey();
final _assistantkey = GlobalKey();
final _gradkey = GlobalKey();


void scrollToSection(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}


  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = null; // Reset previous result
        _isLoading = true;
      });

      // Dummy prediction
      final result = await predictDisease(pickedFile!);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    }
  }

  // Future<String> predictDisease(File image) async {
  //   // Placeholder logic — replace with real ML model call
  //   await Future.delayed(Duration(seconds: 1)); // Simulate processing
  //   return "This is a healthy plant leaf 🌿"; // Dummy class
  // }

  Future<Map<String, dynamic>> predictDisease(XFile imageFile) async {
    try {
      final urlClassify = Uri.parse(
        "https://missingbreath-growth.hf.space/classify",
      );
      final urlRAG = Uri.parse("https://missingbreath-growth.hf.space/RAG");

      // Get image bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // 1. Send to /classify
      var request = http.MultipartRequest('POST', urlClassify);
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var predictionResponse = json.decode(responseBody);

      final int predictionIndex = predictionResponse['prediction'];
      final diseaseName = diseaseClassNames[predictionIndex];

      final gradcam = predictionResponse["gradcam"];
      final ration = predictionResponse["ration"];
      
      Uint8List decodedImage = base64Decode(gradcam);
      
      // 2. Send to /RAG with disease info
      final ragResponse = await http.post(
        urlRAG,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'disease': diseaseName, 'severity': 'severe'}),
      );

      final ragInfo = json.decode(ragResponse.body);
      final String answer = ragInfo['answer'] ?? "";

      return {
        'predictionIndex': predictionIndex,
        'disease': diseaseName,
        'info': answer,
        "gradcam":decodedImage,
        "ration":ration
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_image != null)
                  Container(
                    height: 200,
                    child:
                        kIsWeb
                            ? Image.network(_image!.path, height: 200)
                            : Image.file(File(_image!.path), height: 200),
                  ),
                // const Spacer(),
                _image != null?SizedBox(height: 20):SizedBox(height: 175),

                ElevatedButton.icon(
                  onPressed:
                      _isLoading ? null : () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text("Take Picture"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed:
                      _isLoading ? null : () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text("Choose from Gallery"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                ),
                if (_isLoading)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        "Processing... This might take a little bit.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else if (_result != null)
                 SingleChildScrollView(
                controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.eco,
                                    color: Colors.green[800],
                                    size: 30,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _result!["disease"]!,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                                child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () => scrollToSection(_descriptionKey),
                              child: Text("🌿 Description"),
                            ),
                            ElevatedButton(
                              onPressed: () => scrollToSection(_causesKey),
                              child: Text("🌱 Causes"),
                            ),
                            ElevatedButton(
                              onPressed: () => scrollToSection(_effectsKey),
                              child: Text("🍂 Effects"),
                            ),
                            ElevatedButton(
                              onPressed: () => scrollToSection(_treatmentKey),
                              child: Text("🧪 Treatment"),
                            ),
                            ElevatedButton(
                              onPressed: () => scrollToSection(_preventionKey),
                              child: Text("🛡️ Prevention"),
                            ),
                            ElevatedButton(
                              onPressed: () => scrollToSection(_gradkey),
                              child: Text("🦠 Disease Severity"),
                            ),
                            ElevatedButton(
                              onPressed: () => scrollToSection(_assistantkey),
                              child: Text("🤖 AI Insight"),
                            ),
                            

                            
                          ],
                                                ),
                                              ),
                        ),
                    
                        // Disease Info Cards
                        Builder(
                          builder: (_) {
                            final info = infos[_result!["predictionIndex"]];
                    
                            Widget buildInfoCard(
                              String title,
                              String content,
                              String bgAsset,
                              Key key,
                            ) {
                              return Card(
                                key: key,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.asset(
                                        bgAsset,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                    // Text Section
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            content,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              height: 1.4,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                    
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (info.whatIs.isNotEmpty)
                                  buildInfoCard(
                                    "🌿 Description",
                                    info.whatIs,
                                    'assets/images/err.png',
                                    _descriptionKey,
                                  ),
                                if (info.causes.isNotEmpty)
                                  buildInfoCard(
                                    "🌱 Causes",
                                    info.causes,
                                    'assets/images/cause.jpg',
                                    _causesKey
                                  ),
                                if (info.effects.isNotEmpty)
                                  buildInfoCard(
                                    "🍂 Effects",
                                    info.effects,
                                    'assets/images/effects.jpg',
                                    _effectsKey
                                  ),
                                if (info.treatment.isNotEmpty)
                                  buildInfoCard(
                                    "🧪 Treatment",
                                    info.treatment,
                                    'assets/images/treatment.jpg',
                                    _treatmentKey
                                  ),
                                if (info.prevention.isNotEmpty)
                                  buildInfoCard(
                                    "🛡️ Prevention",
                                    info.prevention,
                                    'assets/images/prevention.jpg',
                                    _preventionKey
                                  ),
                              ],
                            );
                          },
                        ),
SizedBox(height: 20),

                        Container(
  key: _gradkey,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4), // Shadow position
      ),
    ],
  ),
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.only(bottom: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Display the Gradcam Image
      if (_result!["gradcam"] != null)
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            _result!["gradcam"], // Display the decoded image
            fit: BoxFit.cover, // You can adjust this depending on your image's aspect ratio
            height: 250, // Fixed height for image
            width: double.infinity,
          ),
        ),
      if (_result!["gradcam"] == null)
        Center(
          child: Text(
            "No Image Available",
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ),
      
      SizedBox(height: 20),

      // Disease Severity Ratio
      if (_result!["ration"] != null)
        Center(
          child: Text(
          'Disease Severity Ratio: ${_result!["ration"]}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        )
        ),
      if (_result!["ration"] == null)
        Text(
          "Severity Ratio Not Available",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
    ],
  ),
),

                        SizedBox(height: 20),
                    
                        // AI Insight Box
                        if (_result!["info"] != null) ...[
                          Container(
                            key: _assistantkey,
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "🤖 AI Insight:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                SizedBox(height: 10),
                                MarkdownBody(data: _result!["info"]),
                              ],
                            ),
                          ),
                        ],
                        // const GeminiChatBot(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
    );
  }
}
