import 'package:flutter/material.dart';
import 'package:smart_land/services/fertliizerAPi.dart';

class FertilizerPage extends StatefulWidget {
  const FertilizerPage({super.key});

  @override
  _FertilizerPage createState() => _FertilizerPage();
}

class _FertilizerPage extends State<FertilizerPage> {
  int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  final String _imageBaseUrl = 'https://48pmt2mt-7016.uks1.devtunnels.ms';

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
                        suffixIcon: _searchText.isNotEmpty
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
                        Navigator.pushNamed(context, '/fertilizers');
                      },
                      child: const CategoryChip(title: 'Fertilizers', isSelected: true),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/plants');
                      },
                      child: const CategoryChip(title: 'Plants', isSelected: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<List<Fertilizer>>(
                  future: fetchFertilizers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No fertilizers found'));
                    }
                    List<Fertilizer> fertilizers = snapshot.data!.where((fertilizer) {
                      return fertilizer.name.toLowerCase().contains(_searchText.toLowerCase());
                    }).toList();
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      children: fertilizers.map((fertilizer) {
                        return CropCard(
                          name: fertilizer.name,
                          image: '$_imageBaseUrl${fertilizer.imageUrl}',
                          description: fertilizer.description,
                          onArrowTap: () {
                            Navigator.pushNamed(context, '/fertilizer/${fertilizer.id}');
                          },
                        );
                      }).toList(),
                    );
                  },
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
                    errorBuilder: (context, error, stackTrace) {
                      print('Image error in CropCard: $error');
                      return const Icon(Icons.error, size: 50, color: Colors.red);
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