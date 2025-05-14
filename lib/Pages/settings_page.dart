import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:growth/providers/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String appVersion = "1.0.0";
  late SharedPreferences _prefs;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppVersion();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = _prefs.getString('language');
    });
  }

  Future<void> _saveNotificationsEnabled(bool value) async {
    setState(() {
      notificationsEnabled = value;
    });
    await _prefs.setBool('notificationsEnabled', value);
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  Future<void> _changeLanguage(Locale locale) async {
    await _prefs.setString('language', locale.languageCode);
    context.setLocale(locale);
    setState(() {
      _selectedLanguage = locale.languageCode;
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open email app".tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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

        // Main content
        SafeArea(
          child: Column(
            children: [
              // Custom app bar replacement
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Settings'.tr(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(Icons.settings, color: Colors.green),
                  ],
                ),
              ),

              // Settings body
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  children: [
                    // Language Section
                    _buildSectionTitle('language'.tr()),
                    _buildLanguageTile('english'.tr(), 'en', Icons.language),
                    _buildLanguageTile('french'.tr(), 'fr', Icons.language),
                    _buildLanguageTile('arabic'.tr(), 'ar', Icons.language),

                    Divider(),

                    // Theme Switch
                    _buildSectionTitle('Theme'.tr()),
                    SwitchListTile(
                      title: Text("Dark Mode".tr()),
                      value: context.watch<ThemeProvider>().isDarkMode,
                      secondary: Icon(Icons.brightness_6),
                      onChanged: (value) {
                        context.read<ThemeProvider>().toggleTheme(value);
                      },
                    ),

                    // Notifications Toggle
                    _buildSectionTitle('Notifications'.tr()),
                    SwitchListTile(
                      title: Text("Plant Care Tips".tr()),
                      value: notificationsEnabled,
                      secondary: Icon(Icons.notifications_active),
                      onChanged: _saveNotificationsEnabled,
                    ),

                    Divider(),

                    // About App
                    _buildSectionTitle('About growth'.tr()),
                    ListTile(
                      title: Text('Version'.tr()),
                      subtitle: Text(appVersion),
                      leading: Icon(Icons.info_outline),
                    ),
                    ListTile(
                      title: Text('Developer'.tr()),
                      subtitle: Text('Salami Mohamed'),
                      leading: Icon(Icons.person),
                    ),

                    Divider(),

                    // Feedback / Contact
                    _buildSectionTitle('Feedback'.tr()),
                    ListTile(
                      title: Text('Contact Us'.tr()),
                      leading: Icon(Icons.mail_outline),
                      onTap: _sendFeedback,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildLanguageTile(String title, String languageCode, IconData icon) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: _selectedLanguage == languageCode
          ? Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () => _changeLanguage(Locale(languageCode)),
    );
  }
}