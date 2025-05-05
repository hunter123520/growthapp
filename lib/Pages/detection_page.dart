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
    return Scaffold(
      appBar: AppBar(title: Text("Detect Plant Disease".tr()),
      actions:[
        ToggleButtons(
  isSelected: [_selectedIndex == 0, _selectedIndex == 1],
  onPressed: (index) {
    setState(() {
      _selectedIndex = index;
    });
  },
  constraints: BoxConstraints(
    minHeight: 32, // <-- control height here
    minWidth: 100, // optional: adjust width too
  ),
  borderRadius: BorderRadius.circular(12),
  selectedColor: Colors.white,
  fillColor: Colors.green,
  color: Colors.green,
  children: const [
    Text('Single Leaf', style: TextStyle(fontSize: 13)),
    Text('Multi Leaf', style: TextStyle(fontSize: 13)),
  ],
),
      ]),
      
      body: Expanded(
      child: _selectedIndex == 0
          ? SingleDetectionPage()  // Replace with your actual widget
          : MultiDetectionPage(),  // Replace with your actual widget
    ),

      );
  }
}