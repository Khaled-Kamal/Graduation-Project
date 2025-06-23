import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterPage> {
  final Map<String, String?> selections = {
    'Season': null,
    'SoilType': null,
    'WaterNeeds': null,
    'Fertilizer': null,
    'CropType': null,
  };

  final Map<String, List<String>> options = {
    'Season': ['All', 'Summer', 'Winter', 'Year-Round'],
    'SoilType': ['All', 'Sandy', 'Clay', 'Loamy'],
    'WaterNeeds': ['Low', 'Medium', 'High'],
    'Fertilizer': ['Organic', 'Chemical', 'Both'],
    'CropType': ['Vegetables', 'Fruits', 'Grains', 'Legumes'],
  };

  int resultCount = 0;
  final Dio _dio = Dio();

  Future<void> _fetchFilteredCount() async {
    try {
      final params = <String, dynamic>{};
      if (selections['Season'] != null && selections['Season'] != 'All') params['season'] = selections['Season'];
      if (selections['SoilType'] != null && selections['SoilType'] != 'All') params['soilType'] = selections['SoilType'];
      if (selections['WaterNeeds'] != null && selections['WaterNeeds'] != 'All') params['waterNeeds'] = selections['WaterNeeds'];
      if (selections['Fertilizer'] != null && selections['Fertilizer'] != 'All') params['fertilizerCompatibility'] = selections['Fertilizer'];
      if (selections['CropType'] != null && selections['CropType'] != 'All') params['cropType'] = selections['CropType'];

      final response = await _dio.get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/search/filter', queryParameters: params);
      if (response.data['status'] == 'Success') {
        setState(() {
          resultCount = response.data['results'];
        });
      }
    } catch (e) {
      print('Error fetching count: $e');
    }
  }

  void _navigateToResults() async {
    try {
      final params = <String, dynamic>{};
      if (selections['Season'] != null && selections['Season'] != 'All') params['season'] = selections['Season'];
      if (selections['SoilType'] != null && selections['SoilType'] != 'All') params['soilType'] = selections['SoilType'];
      if (selections['WaterNeeds'] != null && selections['WaterNeeds'] != 'All') params['waterNeeds'] = selections['WaterNeeds'];
      if (selections['Fertilizer'] != null && selections['Fertilizer'] != 'All') params['fertilizerCompatibility'] = selections['Fertilizer'];
      if (selections['CropType'] != null && selections['CropType'] != 'All') params['cropType'] = selections['CropType'];

      final response = await _dio.get('https://48pmt2mt-7016.uks1.devtunnels.ms/api/search/filter', queryParameters: params);
      if (response.data['status'] == 'Success') {
        final filteredItems = response.data['data'] as List;
        Navigator.pushNamed(
          context,
          '/result',
          arguments: {'results': filteredItems},
        );
      }
    } catch (e) {
      print('Error navigating: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFilteredCount();
  }

  @override
  Widget build(BuildContext context) {
    final hasFilter = selections.values.any((v) => v != null && v != 'All');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Filter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ...options.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: entry.value.map((option) {
                        final isSelected = selections[entry.key] == option;
                        return ChoiceChip(
                          label: Text(option),
                          selected: isSelected,
                          selectedColor: Colors.green,
                          backgroundColor: Colors.grey.shade200,
                          onSelected: (_) {
                            setState(() {
                              selections[entry.key] = isSelected ? null : option;
                              _fetchFilteredCount();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _navigateToResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      hasFilter
                          ? 'Show $resultCount Results'
                          : 'Select Filters',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => setState(() {
                    selections.updateAll((key, value) => null);
                    _fetchFilteredCount();
                  }),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}