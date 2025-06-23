import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class SoilAnalysisPage extends StatefulWidget {
  const SoilAnalysisPage({super.key});

  @override
  State<SoilAnalysisPage> createState() => _SoilAnalysisPageState();
}

class _SoilAnalysisPageState extends State<SoilAnalysisPage> {
  final Map<String, TextEditingController> _controllers = {
    'nitrogen': TextEditingController(),
    'phosphorous': TextEditingController(),
    'potassium': TextEditingController(),
    'acidity': TextEditingController(),
    'ec': TextEditingController(),
    'organicCarbon': TextEditingController(),
    'sulfur': TextEditingController(),
    'zinc': TextEditingController(),
    'iron': TextEditingController(),
    'copper': TextEditingController(),
    'manganese': TextEditingController(),
    'boron': TextEditingController(),
  };

  final Map<String, List<double>> _validRanges = {
    'nitrogen': [6, 383.0],
    'phosphorous': [2.9, 125.0],
    'potassium': [11.00, 887.00],
    'acidity': [0.90, 11.15],
    'ec': [0.10, 0.95],
    'organicCarbon': [0.10, 24.0],
    'sulfur': [0.64, 31.00],
    'zinc': [0.07, 42.0],
    'iron': [0.21, 44.0],
    'copper': [0.09, 3.02],
    'manganese': [0.11, 31.00],
    'boron': [0.06, 2.82],
  };

  int _currentIndex = 2;
  String _response = '';
  bool _isLoading = false;

  Future<String> predictSoilFertilityWithHttp(List<double> inputs) async {
    try {
      const url = 'https://8e3d-34-55-92-83.ngrok-free.app/predict';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data': [inputs]
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('API Response: $result'); // لتتبع الاستجابة
        String prediction = result['prediction']?.toString() ?? 'No prediction';
        switch (prediction) {
          case 'عالية الخصوبة':
            return '✅ تحليل التربة يظهر أنها عالية الخصوبة\nهذا يعني أن التربة فيها العناصر الغذائية المهمة لنمو النباتات بشكل جيد.\nإذا حابب تعرف أكثر عن أنسب المحاصيل لأرضك أو تحتاج نصائح زراعية، يمكنك تسأل الشات بوت الزراعي، وهو جاهز يساعدك في أي وقت';
          case 'متوسطة الخصوبة':
            return '⚠ تحليل التربة يوضح أنها متوسطة الخصوبة\nممكن تحتاج تضيف أسمدة أو تعدل بعض الخصائص في التربة علشان تتحسن.\nلو حابب تعرف إزاي تحسّن أرضك أو تزرع محاصيل مناسبة، تقدر تكلم الشات بوت الزراعي، وهو هيرد على كل استفساراتك.';
          case 'منخفضة الخصوبة':
            return 'تحليل التربة يوضح أن خصوبتها منخفضة جدًا\nممكن تحتاج تضيف كميات كبيرة من الأسمدة أو تعدل كثير من خصائص التربة علشان تتحسن.\nلو حابب تعرف إزاي تحسّن أرضك أو تختار المحاصيل المناسبة، تقدر تكلم الشات بوت الزراعي، وهو هيرد على كل استفساراتك.';
          default:
            return 'لا يوجد تحليل متاح';
        }
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _handleSubmit() async {
    List<String> errorMessages = [];

    for (var key in _controllers.keys) {
      final text = _controllers[key]!.text;
      final value = double.tryParse(text);

      if (value == null) {
        errorMessages
            .add('Invalid input for $key: Please enter a valid number.');
        continue;
      }

      final range = _validRanges[key]!;
      if (value < range[0] || value > range[1]) {
        errorMessages.add(
            'Invalid value for $key: The value should be between ${range[0]} and ${range[1]}.');
      }
    }

    if (errorMessages.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.only(bottom: 12, right: 8),
          title: const Center(
              child: Icon(Icons.error_outline,
                  color: Color(0xFFEB3E3E), size: 60)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Invalid Input Detected',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFFEB3E3E)),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                for (var errorMessage in errorMessages)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(errorMessage,
                          style: const TextStyle(fontSize: 14))),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back',
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ],
        ),
      );
    } else {
      setState(() {
        _isLoading = true;
        _response = '';
      });

      try {
        List<double> inputs = _controllers.keys
            .map((key) => double.parse(_controllers[key]!.text))
            .toList();
        _response = await predictSoilFertilityWithHttp(inputs);
      } catch (e) {
        _response = 'Error: $e';
      } finally {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            titlePadding: const EdgeInsets.only(top: 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            actionsPadding: const EdgeInsets.only(bottom: 12, right: 8),
            title: const Center(
                child: Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 60)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Soil Analysis Report',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(_response,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buildInputField(String label, String key) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _controllers[key],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), isDense: true),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Soil Analysis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              _buildInputField('Ratio of Nitrogen', 'nitrogen'),
              _buildInputField('Ratio of Phosphorous', 'phosphorous')
            ]),
            Row(children: [
              _buildInputField('Ratio of Potassium', 'potassium'),
              _buildInputField('Soil Acidity', 'acidity')
            ]),
            Row(children: [
              _buildInputField('Electrical Conductivity', 'ec'),
              _buildInputField('Organic Carbon', 'organicCarbon')
            ]),
            Row(children: [
              _buildInputField('Sulfur', 'sulfur'),
              _buildInputField('Zinc', 'zinc')
            ]),
            Row(children: [
              _buildInputField('Iron', 'iron'),
              _buildInputField('Copper', 'copper')
            ]),
            Row(children: [
              _buildInputField('Manganese', 'manganese'),
              _buildInputField('Boron', 'boron')
            ]),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.0))
                  : const Text('Submit'),
            ),
            if (_response.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(_response, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/all');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/soil');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.science_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
