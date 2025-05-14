import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:growth/Pages/detection_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});
  Future<void> triggerAutomation(BuildContext context) async {
      final url = Uri.parse("https://lipw097y.rpcld.com/webhook/2ae06564-81dc-4046-9dc8-8d830c87aac0");

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Automation Completed Successfully'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Handle non-200 responses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request failed with status: ${response.statusCode}')),
          );
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
final List<Map<String, String>> news = [
  {
    'title': '14 states threatened by locust invasion'.tr(),
    'link': 'https://www.facebook.com/share/p/1KukdLZ6KB/',
  },
  {
    'title': 'Plant Exhibition of the City of Blida'.tr(),
    'link': 'https://www.facebook.com/share/p/1GroDN2jbT/',
  },
  {
    'title': 'Algerian President Abdelmadjid Tebboune inaugurated 3 major seawater desalination plants out of 5 in 3 state'.tr(),
    'link': 'https://www.facebook.com/share/p/1GHkTMbkKT/',
  },
  
  // Add more news here
];
    final features = [
      {
        'icon': Icons.science,
        'title': 'Detect Disease'.tr(),
        'bg': Color(0xFFB2DFDB),
      },
      {
        'icon': Icons.bar_chart,
        'title': 'View Reports'.tr(),
        'bg': Color(0xFFBBDEFB),
      },
      {
        'icon': Icons.info_outline,
        'title': 'How It Works'.tr(),
        'bg': Color(0xFFFFF9C4),
      },
      {'icon': Icons.eco, 'title': 'Live Automation'.tr(), 'bg': Color(0xFFDCE775)},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFe6f4ea), Color(0xFFcdeac0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative leaves
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/images/leaf_top_left.png', width: 100),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/leaf_bottom_right.png',
              width: 130,
            ),
          ),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Leaf Doctor".tr(),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 6),
                 Text(
                  "Smart detection for plant leaf diseases.".tr(),
                  style: TextStyle(fontSize: 14.5, color: Colors.black87),
                ),
                const SizedBox(height: 24),

                Text(
  "Detection Summary".tr(),
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF2E7D32),
    letterSpacing: 0.4,
  ),
),

                const SizedBox(height: 14),

                // Star-like stat layout
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children:  [
                      _StatBox(label: "Total Scans".tr(), value: "1245"),
                      _StatBox(label: "Healthy".tr(), value: "930"),
                      _StatBox(label: "Diseased".tr(), value: "315"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                 Text(
  "App Features".tr(),
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF2E7D32),
    letterSpacing: 0.4,
  ),
),

                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  itemCount: features.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    // childAspectRatio: 1,
                    childAspectRatio: 2,

                  ),
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return InkWell(
                      
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        final title = feature['title'].toString();

                        if (title == 'Detect Disease') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DetectionPage()));
                        }else if(title == "Live Automation"){
                          triggerAutomation(context);
                        } else {
                          // You can handle other feature navigation here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Page for "$title" is not implemented yet.',
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: feature['bg'] as Color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 14,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              feature['icon'] as IconData,
                              size: 26,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              feature['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
                 Text(
                  "Latest News".tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),

                ListView.builder(
  shrinkWrap: true,
  itemCount: news.length, // List of news titles
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    final newsItem = news[index];
    return InkWell(
      onTap: () {
        // Navigate to the news link (example for Facebook)
        _launchURL(newsItem['link']!);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Icon(
              Icons.article,
              size: 30,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                newsItem['title']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  },
),

                const SizedBox(height: 30),


              ],
            ),
          ),

          // Logo bottom left
          Positioned(
            bottom: 10,
            left: 10,
            child: Opacity(
            
              opacity: 0.9,
              child: Image.asset('assets/images/logo/logo.png', width: 50),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF388E3C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final String title;
  const FeaturePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Center(
        child: Text(
          "Welcome to $title page!",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
