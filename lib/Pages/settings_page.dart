import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:growth/providers/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  void _changeLanguage(Locale locale) {
    context.setLocale(locale);
  }

  void _sendFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'sellami.mohammedabdelhadi@univ-ouargla.dz',
      queryParameters: {'subject': 'growth App Feedback'},
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not open email app")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        children: [
          // Language Section
          _buildSectionTitle('language'.tr()),
          ListTile(
            title: Text('english'.tr()),
            leading: Icon(Icons.language),
            onTap: () => _changeLanguage(Locale('en')),
          ),
          ListTile(
            title: Text('french'.tr()),
            leading: Icon(Icons.language),
            onTap: () => _changeLanguage(Locale('fr')),
          ),
          ListTile(
            title: Text('arabic'.tr()),
            leading: Icon(Icons.language),
            onTap: () => _changeLanguage(Locale('ar')),
          ),

          Divider(),

          // Theme Switch
          _buildSectionTitle('Theme'),
          SwitchListTile(
            title: Text("Dark Mode"),
            value: context.watch<ThemeProvider>().isDarkMode,
            secondary: Icon(Icons.brightness_6),
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
          ),

          // Notifications Toggle
          _buildSectionTitle('Notifications'),
          SwitchListTile(
            title: Text("Plant Care Tips"),
            value: notificationsEnabled,
            secondary: Icon(Icons.notifications_active),
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
              // Save to shared preferences if needed
            },
          ),

          Divider(),

          // About App
          _buildSectionTitle('About growth'),
          ListTile(
            title: Text('Version'),
            subtitle: Text(appVersion),
            leading: Icon(Icons.info_outline),
          ),
          ListTile(
            title: Text('Developer'),
            subtitle: Text('Salami Mohamed'),
            leading: Icon(Icons.person),
          ),

          Divider(),

          // Feedback / Contact
          _buildSectionTitle('Feedback'),
          ListTile(
            title: Text('Contact Us'),
            leading: Icon(Icons.mail_outline),
            onTap: _sendFeedback,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
