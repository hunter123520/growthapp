import 'package:flutter/material.dart';
import 'package:growth/Pages/home_page.dart';
import 'package:growth/Pages/detection_page.dart';
import 'package:growth/Pages/settings_page.dart';
import 'package:growth/Pages/gemini_page.dart';
import 'package:growth/Pages/community_page.dart';
import 'package:growth/Pages/sensors_page.dart';
import 'package:growth/Widgets/bottom_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:growth/Pages/choosepage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform, // <- this is required
  // );


  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: growthApp(),
      ),
    ),
  );
}

class growthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'growth',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MainNavigation(), // Replace with your HomePage if needed
    );
  }
}


class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), PlantTypeSelectionPage(),SensorsPage(),CommunityScreen(),AssistantPage(), SettingsPage()];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';
    return Scaffold(
      body: Stack(
      children: [
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
          if(isArabic)
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset('assets/images/leaf_top_right.png', width: 100),
            )
          else
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/images/leaf_top_left.png', width: 100),
            ),

          if(isArabic)
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/leaf_bottom_left.png',
                width: 130,
              ),
            )
          else
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/leaf_bottom_right.png',
                width: 130,
              ),
            ),
          _pages[_currentIndex]]),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
