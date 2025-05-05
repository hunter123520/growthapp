import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_markdown/flutter_markdown.dart';

class GeminiChatBot extends StatefulWidget {
  const GeminiChatBot({super.key});

  @override
  State<GeminiChatBot> createState() => _GeminiChatBotState();
}

class _GeminiChatBotState extends State<GeminiChatBot> {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  List<String> _questions = [];
  List<String> _answers = [];
  bool _isListening = false;
  bool _isWaiting = false;

  static const String apiKey = 'AIzaSyCZVM0_yjl3Un-mR32EgG1lnFxgQOBNOhE';

  Future<void> _sendQuestion(String question) async {
    setState(() {
      _isWaiting = true;
      _questions.add(question);
    });

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );
    final disease_info_text = "This comprehensive report details prevalent plant diseases affecting key crops in Algeria, along with organic and chemical treatment options. Tomato Diseases: Fusarium Wilt: Caused by Fusarium oxysporum f. sp. lycopersici (FOL) and F. oxysporum f. sp. radicis-lycopersici (FORL). Prevalent in North Algeria (Tlemcen, Oran, Mostaganem, Guelma, Sekikda) from 2012-2016. FOL races 2 and 3 identified. FORL common in Mediterranean countries, including Algeria. Early Blight: Caused by Alternaria solani and A. grandis. Prevalent in northwestern Algeria. Favored by warm, wet conditions. Tomato Leaf Curl New Delhi Virus (ToLCNDV): First reported in Algeria (Biskra) in 2019, affecting zucchini, melon, and cucumber. Stemphylium Leaf Spot: Caused by Stemphylium spp. Over 30% infection rate in northwestern Algeria (2018). Five species identified, including new reports for Algeria. Often co-occurs with Alternaria spp. Late Blight: Caused by Phytophthora infestans. Major clonal lineages (EU_13_A2, EU_2_A1, EU_23_A1) present. Linked to warm, rainy periods. Bacterial Canker: Caused by Clavibacter michiganensis subsp. michiganensis. Primarily in the Mediterranean area, including Algeria. Seed-borne. Tomato Brown Rugose Fruit Virus (ToBRFV): Causes black spots on fruits and leaf changes. Limited information on prevalence and management in the text. Date Palm Diseases: Bayoud Disease: Caused by Fusarium oxysporum f. sp. albedinis (Foa). Severe threat in western and central Algerian Sahara (Bechar, Adrar). Destroyed millions of palms. Black Scorch: Caused by Thielaviopsis punctulata. Manifests as hard, black lesions. Can cause neck bending and death. Brittle Leaf Disease: Lethal disease first reported in Biskra. Leaves become brittle, linked to manganese deficiency. Inflorescence Rot (Khamedj): Caused by fungi like Mauginiella scaetae and Thielaviopsis paradoxa. Causes brown rot of inflorescences, reducing fruit development. Wheat Diseases: Powdery Mildew, Yellow Rust, Brown Rust: Common foliar fungal diseases causing significant yield losses. Fungicide applications (azoxystrobin, cyproconazole, propiconazole) at stem elongation, booting, and heading stages are effective (up to 91.66% reduction in yellow rust severity with three applications). Fusarium Head Blight (FHB) and Fusarium Crown Rot (FCR): FCR causes yield losses in most wheat-growing areas. FHB can lead to mycotoxin contamination. Seed treatment with triazoles (tebuconazole, fludioxonil + difenoconazole) is effective. Biological control agents like Pseudomonas azotoformans and Trichoderma gamsii show potential against FCR. Ascochyta Leaf Spot: Caused by Ascochyta tritici. Favored by rainy, humid conditions. Control includes healthy, treated seeds, crop rotation, and foliar fungicides. Biological control agents (Trichoderma spp., Pseudomonas fluorescens, Bacillus spp.) show promise. Barley Yellow Dwarf Virus (BYDV): Destructive viral disease. Surveys (2014-2016) in seven regions revealed BYDV-PAV in barley, durum wheat, soft wheat, and oats. Can cause 20-80% yield loss in severe infections. Bipolaris Root Rot and Leaf Spot: Caused by Bipolaris sorokiniana. Affects all parts of the plant, limiting yield and quality. Citrus Diseases: Citrus Tristeza Virus (CTV): Serious threat. Severe VT genotype identified in Chlef Valley. Causes decline, stem pitting, and leaf yellowing. Management focuses on eradication and aphid vector control. Scaly Bark Psorosis, Concave Gum-Blind Pocket, Infectious Variegation: Widespread viral or virus-like diseases causing decline in Mediterranean citrus areas, including Algeria. Colletotrichum Anthracnose: Caused by Colletotrichum gloeosporioides. First report on citrus in Algeria, causing wither-tip on sweet orange and lemon. Potato Diseases: Potato Cyst Nematodes: Globodera pallida and G. rostochiensis present in Algeria. Early Blight: Caused by Alternaria grandis and A. protenta. Severe in northwestern Algeria. Fusarium Wilt and Tuber Dry Rot: Caused by Fusarium spp. (F. sambucinum particularly aggressive). Late Blight: Caused by Phytophthora infestans. Epidemics linked to rainy periods. Bacterial Soft Rot: Caused by Pectobacterium carotovorum. Reported in Western Algeria. Other Vegetable Diseases: Tomato Yellow Leaf Curl Bigeminivirus: Occurs in Algeria. Corn Leaf Spot and Leaf Blight: Caused by Bipolaris and Exserohilum spp. Several species newly identified in Algeria as causal agents. Downy Mildew of Cucurbits: Potential concern requiring specialized fungicides.";
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "You are a chatbot called Growth, and you assist users with plant leaf disease identification and solutions. You should answer user questions based on the information provided in this text: $disease_info_text, the application features are: Extend Beyond Detection: Add Decision Support 2. Real-Time Multi-Plant Monitoring System 3. Offline Capability for Remote Farmers 4. Geo-AI for Regional Disease Prediction 5. Explainable AI (XAI)6. Community Reporting & AI Feedback Loop 7. Multi-Disease and Multi-Plant Support. The user's question is:$question"},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply =
          data["candidates"][0]["content"]["parts"][0]["text"] ?? "No response";
      setState(() {
        _answers.add(reply);
      });
    } else {
      setState(() {
        _answers.add("Error: ${response.reasonPhrase}");
      });
    }

    setState(() {
      _isWaiting = false;
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        localeId: 'ar_EG',
        onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
          });
          if (val.hasConfidenceRating && val.confidence > 0) {
            _speech.stop();
            _sendQuestion(val.recognizedWords);
            setState(() => _isListening = false);
          }
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text("Plant Disease Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final isLast = index == _questions.length - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // User Message
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/user.png',
                          ), // 👤 Your user image
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _questions[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Bot Reply
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/bot.jpg',
                          ), // 🤖 Your bot image
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                isLast && _isWaiting
                                    ? const CircularProgressIndicator()
                                    : MarkdownBody(data: _answers[index]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Ask something...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    _sendQuestion(text);
                    _controller.clear();
                  }
                },
              ),
              IconButton(
                icon: Icon(_isListening ? Icons.stop : Icons.mic),
                color: _isListening ? Colors.red : Colors.black,
                onPressed: _isListening ? _stopListening : _startListening,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
