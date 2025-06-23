import 'package:flutter/material.dart';
import 'package:smart_land/services/fertliizerAPi.dart';
import 'package:smart_land/services/fetchFertilizerById.dart'; // افترض إن الـ Fertilizer Model موجود هنا

class ManurePage extends StatefulWidget {
  final int fertilizerId;

  const ManurePage({super.key, required this.fertilizerId});

  @override
  _ManurePageState createState() => _ManurePageState();
}

class _ManurePageState extends State<ManurePage> {
  final String _imageBaseUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: FutureBuilder<Fertilizer>(
          future: fetchFertilizerById(widget.fertilizerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }

            final fertilizer = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        iconSize: 24,
                      ),
                    ),
                  ),
                  Image.network(
                    '$_imageBaseUrl${fertilizer.imageUrl}',
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 50, color: Colors.red);
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fertilizer.name,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${fertilizer.type} Fertilizer',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fertilizer.description,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Overview',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOverviewItem(Icons.wb_sunny_outlined, 'Nitrogen', fertilizer.nitrogenContent),
                            _buildOverviewItem(Icons.thermostat_outlined, 'Phosphorus', fertilizer.phosphorusContent),
                            _buildOverviewItem(Icons.water_drop_outlined, 'Potassium', fertilizer.potassiumContent),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverviewItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, size: 32, color: const Color(0xFF2E7D32)),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}