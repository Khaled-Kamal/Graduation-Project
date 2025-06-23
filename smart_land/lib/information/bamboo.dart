import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BambooPage extends StatefulWidget {
  final int id;

  const BambooPage({super.key, required this.id});

  @override
  _BambooPageState createState() => _BambooPageState();
}

class _BambooPageState extends State<BambooPage> {
  late Future<Map<String, dynamic>> _plantDetails;

  @override
  void initState() {
    super.initState();
    print('Fetching plant with id: ${widget.id}'); 
    _plantDetails = fetchPlantDetails(widget.id);
  }

  Future<Map<String, dynamic>> fetchPlantDetails(int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Plants/$id',
      );
      if (response.statusCode == 200) {
        print('Received data for id $id: ${response.data}'); 
        return response.data;
      } else {
        throw Exception('Failed to load plant details, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching plant: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _plantDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final plant = snapshot.data!;
              final imageUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms${plant['imageUrl']}';
              print('Image URL in BambooPage: $imageUrl'); 
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
                      imageUrl,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('Image error in BambooPage: $error');
                        return const Icon(Icons.error, size: 50, color: Colors.red);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
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
                            plant['name'] ?? 'No Name',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plant['scientificName'] ?? 'N/A',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Description',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plant['description'] ?? 'No description available',
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
                              _buildOverviewItem(Icons.wb_sunny_outlined, 'LIGHT', plant['lightRequirements'] ?? 'N/A'),
                              _buildOverviewItem(Icons.thermostat_outlined, 'TEMPERATURE', plant['temperatureRange'] ?? 'N/A'),
                              _buildOverviewItem(Icons.water_drop_outlined, 'WATER', plant['waterNeeds'] ?? 'N/A'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(); // Default case
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