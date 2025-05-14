import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:growth/Pages/detection_page.dart';
import 'package:growth/Pages/detection_page_palm.dart';
class PlantTypeSelectionPage extends StatefulWidget {
  const PlantTypeSelectionPage({super.key});

  @override
  State<PlantTypeSelectionPage> createState() => _PlantTypeSelectionPageState();
}

class _PlantTypeSelectionPageState extends State<PlantTypeSelectionPage> {
  bool _isDatePlantSelected = true;
  bool _selectionMade = false;
  bool _buttonclicked = false;

  void _selectPlantType(bool isDatePlant) {
    setState(() {
      _isDatePlantSelected = isDatePlant;
      _selectionMade = true;
    });
  }

  void _continueToDetection() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => DetectionPage()),
    // );
    setState(() {
      _buttonclicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_buttonclicked == false)
          Scaffold(
            body: Stack(
              children: [
                // Background images
                Row(
                  children: [
                    // Date Palm Side
                    Flexible(
                      flex: _isDatePlantSelected ? 7 : 3,
                      child: _PlantBackground(
                        imagePath: 'assets/images/date.png',
                        isActive: _isDatePlantSelected,
                        label: 'DATE PALM'.tr(),
                        showButton: _selectionMade && _isDatePlantSelected,
                        onTap: () => _selectPlantType(true),
                        onContinue: _continueToDetection,
                      ),
                    ),
                    // Regular Plants Side
                    Flexible(
                      flex: _isDatePlantSelected ? 3 : 7,
                      child: _PlantBackground(
                        imagePath: 'assets/images/regular.png',
                        isActive: !_isDatePlantSelected,
                        label: 'REGULAR PLANTS'.tr(),
                        showButton: _selectionMade && !_isDatePlantSelected,
                        onTap: () => _selectPlantType(false),
                        onContinue: _continueToDetection,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if(_buttonclicked && _isDatePlantSelected)
            DetectionPalmPage()
          else if(_buttonclicked)
            DetectionPage()
      ],
    );
  }
}

class _PlantBackground extends StatelessWidget {
  final String imagePath;
  final bool isActive;
  final String label;
  final bool showButton;
  final VoidCallback onTap;
  final VoidCallback onContinue;

  const _PlantBackground({
    required this.imagePath,
    required this.isActive,
    required this.label,
    required this.showButton,
    required this.onTap,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter:
                isActive
                    ? null
                    : ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),

            // Text and Button Column
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Plant type label
                  AnimatedOpacity(
                    opacity: isActive ? 1.0 : 0.6,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isActive ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Continue Button (appears below text)
                  if (showButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: onContinue,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continue'.tr(),
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.green[800],
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
