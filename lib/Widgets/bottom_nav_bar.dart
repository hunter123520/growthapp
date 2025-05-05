import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
  selectedItemColor: Colors.deepPurple,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Detect'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.sensors_rounded), label: 'Sensors'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.smart_toy_rounded), label: 'Assistant'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'.tr()),
      ],
    );
  }
}
