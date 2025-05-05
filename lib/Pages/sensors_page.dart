import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  final _formKey = GlobalKey<FormState>();
  final Random random = Random();

String classifyRegion(double lat, double lon) {
  if (lat >= 30 && lat <= 40 && lon >= -100 && lon <= -85) return 'Central USA';
  if (lat >= -5 && lat <= 10 && lon >= 30 && lon <= 40) return 'East Africa';
  if (lat >= 25 && lat <= 35 && lon >= 75 && lon <= 85) return 'North India';
  if (lat >= 10 && lat <= 20 && lon >= 75 && lon <= 85) return 'South India';
  if (lat >= 25 && lat <= 35 && lon >= -110 && lon <= -90) return 'South USA';

  // ✅ North Africa covers Algeria, Tunisia, Libya, Egypt, Morocco, Sudan
  if (lat >= 20 && lat <= 37 && lon >= -18 && lon <= 35) return 'North Africa';

  return 'North Africa';//'Unknown Region';
}

String getCategory(int index) {
  switch (index) {
    case 0:
      return "Mild";
    case 1:
      return "Moderate";
    case 2:
      return "Severe";
    default:
      return "Unknown";
  }
}

List<double> softmax(List<dynamic> logits) {
  final exps = logits.map((l) => exp(l.toDouble())).toList();
  final sum = exps.reduce((a, b) => a + b);
  return exps.map((e) => e / sum).toList();
}


Future<void> getLocationAndClassifyRegion() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location services are disabled")),
    );
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location permissions are permanently denied")),
    );
    return;
  }

  final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  setState(() {
    latitudeController.text = position.latitude.toStringAsFixed(5);
    longitudeController.text = position.longitude.toStringAsFixed(5);
    region = classifyRegion(position.latitude, position.longitude);
  });

  print("Location: (${position.latitude}, ${position.longitude}) => Region: $region");
}


  // Categorical options
  final List<String> regions = [
    'Central USA', 'East Africa', 'North Africa' ,'North India', 'South India', 'South USA'
  ];
  final List<String> cropTypes = ['Cotton', 'Maize', 'Rice', 'Soybean', 'Wheat'];
  final List<String> irrigationTypes = ['Drip', 'Manual', 'Sprinkler'];
  final List<String> fertilizerTypes = ['Inorganic', 'Mixed', 'Organic'];

  // Selected values
  String region = 'Central USA';
  String cropType = 'Wheat';
  String irrigationType = 'Drip';
  String fertilizerType = 'Organic';

  // Controllers for numeric fields
  late TextEditingController soilMoistureController;
  late TextEditingController soilPHController;
  late TextEditingController temperatureController;
  late TextEditingController rainfallController;
  late TextEditingController humidityController;
  late TextEditingController sunlightController;
  late TextEditingController pesticideController;
  late TextEditingController totalDaysController;
  late TextEditingController yieldController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController ndviController;

  @override
  void initState() {
    super.initState();
    soilMoistureController = TextEditingController(text: "30");
    soilPHController = TextEditingController(text: "6.5");
    temperatureController = TextEditingController(text: "25");
    rainfallController = TextEditingController(text: "100");
    humidityController = TextEditingController(text: "50");
    sunlightController = TextEditingController(text: "8");
    pesticideController = TextEditingController(text: "100");
    totalDaysController = TextEditingController(text: "90");
    yieldController = TextEditingController(text: "3000");
    latitudeController = TextEditingController(text: "23.5");
    longitudeController = TextEditingController(text: "78.9");
    ndviController = TextEditingController(text: "0.6");
  }

  void randomizeValues() {
    setState(() {
      soilMoistureController.text = (random.nextDouble() * 100).toStringAsFixed(1);
      soilPHController.text = (4 + random.nextDouble() * 4).toStringAsFixed(2);
      temperatureController.text = (15 + random.nextDouble() * 20).toStringAsFixed(1);
      rainfallController.text = (random.nextDouble() * 200).toStringAsFixed(1);
      humidityController.text = (random.nextDouble() * 100).toStringAsFixed(1);
      sunlightController.text = (random.nextDouble() * 12).toStringAsFixed(1);
      pesticideController.text = (random.nextDouble() * 200).toStringAsFixed(1);
      totalDaysController.text = (30 + random.nextDouble() * 120).toStringAsFixed(1);
      yieldController.text = (1000 + random.nextDouble() * 5000).toStringAsFixed(1);
      latitudeController.text = (-90 + random.nextDouble() * 180).toStringAsFixed(5);
      longitudeController.text = (-180 + random.nextDouble() * 360).toStringAsFixed(5);
      ndviController.text = (random.nextDouble()).toStringAsFixed(3);
    });
  }

 void submit() async {
  final url = Uri.parse("https://missingbreath-growth.hf.space/GeoSensor"); // Replace this

  final data = {
    'region': region == 'North Africa' ? "East Africa" : region,
    'crop_type': cropType,
    'soil_moisture': double.tryParse(soilMoistureController.text) ?? 0,
    'soil_pH': double.tryParse(soilPHController.text) ?? 0,
    'temperature_C': double.tryParse(temperatureController.text) ?? 0,
    'rainfall_mm': double.tryParse(rainfallController.text) ?? 0,
    'humidity': double.tryParse(humidityController.text) ?? 0,
    'sunlight_hours': double.tryParse(sunlightController.text) ?? 0,
    'irrigation_type': irrigationType,
    'fertilizer_type': fertilizerType,
    'pesticide_usage_ml': double.tryParse(pesticideController.text) ?? 0,
    'total_days': int.tryParse(totalDaysController.text) ?? 0,
    'yield_kg_per_hectare': double.tryParse(yieldController.text) ?? 0,
    'latitude': double.tryParse(latitudeController.text) ?? 0,
    'longitude': double.tryParse(longitudeController.text) ?? 0,
    'NDVI_index': double.tryParse(ndviController.text) ?? 0,
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final int answer = json['answer'];
      final List<dynamic> logits = json['logits'];
      // print(softmax(logits));
      final List percentages = logits;//softmax(logits);

      final categories = ["Mild", "Moderate", "Severe"];

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Detection Result", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Diagnosis: ${getCategory(answer)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
              const SizedBox(height: 12),
              ...List.generate(categories.length, (i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${categories[i]}: ${(percentages[i] * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(fontSize: 14)),
                    LinearProgressIndicator(
                      value: percentages[i],
                      backgroundColor: Colors.grey[300],
                      color: i == answer ? Colors.deepPurple : Colors.blueAccent,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        ),
      );
    } else {
      throw Exception("Failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text("Something went wrong:\n$e"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }
}



 Widget buildDropdown(String label, String current, List<String> options, void Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    value: current,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    dropdownColor: Colors.white,
    icon: const Icon(Icons.arrow_drop_down),
    items: options
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: onChanged,
  );
}

Widget buildField(String label, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}


  Widget rowFields(String label1, TextEditingController c1, String label2, TextEditingController c2) {
    return Row(
      children: [
        Expanded(child: buildField(label1, c1)),
        const SizedBox(width: 12),
        Expanded(child: buildField(label2, c2)),
      ],
    );
  }

  @override
  void dispose() {
    soilMoistureController.dispose();
    soilPHController.dispose();
    temperatureController.dispose();
    rainfallController.dispose();
    humidityController.dispose();
    sunlightController.dispose();
    pesticideController.dispose();
    totalDaysController.dispose();
    yieldController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    ndviController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Sensors & GeoLocation Based Detection'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: randomizeValues,
            tooltip: "Randomize Inputs",
          ),
        ],
      ),
      body:Form(
  key: _formKey,
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Button color
        foregroundColor: Colors.white, // Text/Icon color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.4),
      ),
      icon: const Icon(Icons.location_on),
      label:  Text(
        "Get Location".tr(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onPressed: getLocationAndClassifyRegion,
    ),
  ],
),

        const SizedBox(height: 10),
        buildDropdown("Region".tr(), region, regions, (v) => setState(() => region = v!)),
        const SizedBox(height: 10),
        buildDropdown("Crop Type".tr(), cropType, cropTypes, (v) => setState(() => cropType = v!)),
        const SizedBox(height: 10),
        buildDropdown("Irrigation Type".tr(), irrigationType, irrigationTypes, (v) => setState(() => irrigationType = v!)),
        const SizedBox(height: 10),
        buildDropdown("Fertilizer Type".tr(), fertilizerType, fertilizerTypes, (v) => setState(() => fertilizerType = v!)),
        const SizedBox(height: 10),
        buildField("Soil Moisture (%)".tr(), soilMoistureController),
        const SizedBox(height: 10),
        buildField("Soil pH".tr(), soilPHController),
        const SizedBox(height: 10),
        rowFields("Temperature (°C)".tr(), temperatureController, "Rainfall (mm)".tr(), rainfallController),
        const SizedBox(height: 10),
        rowFields("Humidity (%)".tr(), humidityController, "Sunlight (hrs)".tr(), sunlightController),
        const SizedBox(height: 10),
        rowFields("Pesticide (ml)".tr(), pesticideController, "Total Days".tr(), totalDaysController),
        const SizedBox(height: 10),
        buildField("Yield (kg/hectare)".tr(), yieldController),
        const SizedBox(height: 10),
        rowFields("Latitude".tr(), latitudeController, "Longitude".tr(), longitudeController),
        const SizedBox(height: 10),
        buildField("NDVI Index".tr(), ndviController),
        const SizedBox(height: 20),
        Center(
  child: ElevatedButton.icon(
    icon: const Icon(Icons.science_outlined, size: 22),
    label:  Text(
      "Detect".tr(),
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
    onPressed: submit,
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(180, 45),
      backgroundColor: Colors.teal[600],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Less rounded
      ),
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 20),
    ),
  ),
),

      ],
    ),
  ),
),
    );
  }
}
