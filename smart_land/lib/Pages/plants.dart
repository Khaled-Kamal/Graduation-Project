import 'package:flutter/material.dart';
import 'package:smart_land/services/plantApi.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  _PlantsPage createState() => _PlantsPage();
}

class _PlantsPage extends State<PlantsPage> {
  int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Plant> _plants = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    try {
      final plants = await fetchPlants();
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/categories');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/analyze');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chat');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Plant> _filteredPlants = _plants.where((plant) {
      return plant.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Find a crop, fertilizer, or plant...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchText = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.green),
                      onPressed: () {
                        Navigator.pushNamed(context, '/filter');
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/all');
                      },
                      child: const CategoryChip(title: 'All', isSelected: false),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const CategoryChip(title: 'Crops', isSelected: false),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/Fertilizers');
                      },
                      child: const CategoryChip(title: 'Fertilizers', isSelected: false),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/plants');
                      },
                      child: const CategoryChip(title: 'Plants', isSelected: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                            children: _filteredPlants.map((plant) {
                              // تصحيح URL الصور
                              String imageUrl = plant.imageUrl;
                              if (!imageUrl.startsWith('http')) {
                                imageUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms/uploads/$imageUrl';
                              } else if (imageUrl.contains('https//')) {
                                imageUrl = imageUrl.replaceAll('https//', 'https://');
                              }
                              print('Corrected Image URL for ${plant.name}: $imageUrl'); // للتحقق
                              return CropCard(
                                name: plant.name,
                                image: imageUrl,
                                description: plant.description,
                                onArrowTap: () {
                                  print('Navigating to plant with id: ${plant.id}'); // للتحقق
                                  Navigator.pushNamed(context, '/plant/${plant.id}');
                                },
                              );
                            }).toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.science_outlined), label: 'Analyze'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryChip({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(title),
        backgroundColor: isSelected ? Colors.green : const Color(0xFFF5F5F5),
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String name;
  final String image;
  final String description;
  final VoidCallback onArrowTap;

  const CropCard({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Image error for $name: $error'); // لتحديد الخطأ
                      return Container(
                        color: Colors.grey,
                        child: const Center(child: Text('Image not available')),
                      );
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onArrowTap,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.green,
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}