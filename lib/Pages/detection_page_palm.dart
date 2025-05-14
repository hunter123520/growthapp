import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:growth/Pages/multi_detection_palm.dart';
import 'package:growth/Pages/single_detection_palm.dart';

class DetectionPalmPage extends StatefulWidget {
  const DetectionPalmPage({super.key});

  @override
  State<DetectionPalmPage> createState() => _DetectionPalmPageState();
}

class _DetectionPalmPageState extends State<DetectionPalmPage> {
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
        "Detect Palm Disease".tr(),
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
                ?  SinglePalmDetectionPage()
                : MultiPalmDetectionPage(),
          ),
        ],
      ),
    );
  }
}

