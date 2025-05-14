import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:growth/Pages/multi_detection.dart';
import 'package:growth/Pages/single_detection.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Custom AppBar-style container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
     Flexible(
      child: Text(
        "Detect Plant Disease".tr(),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
    ),
    ToggleButtons(
      isSelected: [_selectedIndex == 0, _selectedIndex == 1],
      onPressed: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      constraints: const BoxConstraints(
        minHeight: 32,
        minWidth: 100,
      ),
      borderRadius: BorderRadius.circular(12),
      selectedColor: Colors.white,
      fillColor: Colors.green,
      color: Colors.green,
      children:  [
        Text('Single Leaf'.tr(), style: TextStyle(fontSize: 13)),
        Text('Multi Leaf'.tr(), style: TextStyle(fontSize: 13)),
      ],
    ),
  ],
)

          ),
          const SizedBox(height: 8),
          // Main content area
          Expanded(
            child: _selectedIndex == 0
                ?  SingleDetectionPage()
                : MultiDetectionPage(),
          ),
        ],
      ),
    );
  }
}

