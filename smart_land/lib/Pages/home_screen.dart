import 'package:flutter/material.dart';
import 'package:smart_land/Pages/all_category.dart';
import 'package:smart_land/Pages/chat.dart';
import 'package:smart_land/Pages/crop.dart';
import 'package:smart_land/Pages/fertilizer.dart';
import 'package:smart_land/Pages/filter_page.dart';
import 'package:smart_land/Pages/notification_screen.dart';
import 'package:smart_land/Pages/plants.dart';
import 'package:smart_land/Pages/soil_analysis_page.dart';
import 'dart:math' as math;
import 'package:smart_land/pages_Profiles/ProfileScreen.dart';
import 'package:smart_land/services/homeService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String? _userName;
  String? _profilePictureUrl;
  List<Map<String, dynamic>> _allItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadUserData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Khaled Kamal';
      _profilePictureUrl = prefs.getString('profile_picture_url');
    });
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _searchResults = _allItems
            .where((item) => item['title']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _searchResults = [];
      }
    });
  }

  List<Map<String, dynamic>> _convertApiDataToItems(HomeResponse data) {
    List<Map<String, dynamic>> items = [];
    for (var plant in data.plants.take(2)) {
      items.add({
        'id': plant.id,
        'title': plant.name,
        'desc': plant.description,
        'img': 'https://48pmt2mt-7016.uks1.devtunnels.ms${plant.imageUrl}',
        'imageWidth': 117.0,
        'imageHeight': 94.0,
        'imageTop': 10.0,
        'imageLeft': 23.0,
        'category': 'Plant',
      });
    }
    for (var crop in data.crops.take(2)) {
      items.add({
        'id': crop.id,
        'title': crop.name,
        'desc': crop.description,
        'img': 'https://48pmt2mt-7016.uks1.devtunnels.ms${crop.imageUrl}',
        'imageWidth': 117.0,
        'imageHeight': 94.0,
        'imageTop': 10.0,
        'imageLeft': 23.0,
        'category': 'Crop',
      });
    }
    for (var fertilizer in data.fertilizers.take(2)) {
      items.add({
        'id': fertilizer.id,
        'title': fertilizer.name,
        'desc': fertilizer.description,
        'img': 'https://48pmt2mt-7016.uks1.devtunnels.ms${fertilizer.imageUrl}',
        'imageWidth': 117.0,
        'imageHeight': 94.0,
        'imageTop': 10.0,
        'imageLeft': 23.0,
        'category': 'Fertilizer',
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: _profilePictureUrl != null && _profilePictureUrl!.isNotEmpty
                    ? NetworkImage(_profilePictureUrl!)
                    : const AssetImage('assets/PROFILE.png') as ImageProvider,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome,", style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(_userName ?? 'Khaled Kamal',
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.green),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<HomeResponse>(
          future: fetchHomeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }
            _allItems = _convertApiDataToItems(snapshot.data!);
            return ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Find a crop, fertilizer, or plant...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          suffixIcon: _isSearching
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.filter_list, color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isSearching
                    ? _buildSearchResults()
                    : Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(bottom: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildCategory('assets/wheet.png', 'Crops', onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CropPage()));
                              }),
                              const SizedBox(width: 16),
                              _buildCategory('assets/ferterlize.png', 'Fertilizers', onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizerPage()));
                              }),
                              const SizedBox(width: 16),
                              _buildCategory('assets/plant.png', 'Plants', onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PlantsPage()));
                              }),
                            ],
                          ),
                          _sectionHeader("Explore Plants", onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PlantsPage()));
                          }),
                          _cardImageHorizontalList(_allItems.where((item) => item['category'] == 'Plant').toList()),
                          _sectionHeader("Crop Library", onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CropPage()));
                          }),
                          _cardImageHorizontalList(_allItems.where((item) => item['category'] == 'Crop').toList()),
                          _sectionHeader("Fertilizer Guide", onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizerPage()));
                          }),
                          _cardImageHorizontalList(_allItems.where((item) => item['category'] == 'Fertilizer').toList()),
                        ],
                      ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllCategory()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => SoilAnalysisPage()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.science_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text('No results found', style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }
    Map<String, List<Map<String, dynamic>>> groupedResults = {
      'Plants': _searchResults.where((item) => item['category'] == 'Plant').toList(),
      'Crops': _searchResults.where((item) => item['category'] == 'Crop').toList(),
      'Fertilizers': _searchResults.where((item) => item['category'] == 'Fertilizer').toList(),
    };
    List<Widget> sections = [];
    groupedResults.forEach((category, items) {
      if (items.isNotEmpty) {
        final limitedItems = items.take(2).toList();
        sections.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(category, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => category == 'Plants'
                        ? PlantsPage()
                        : category == 'Crops'
                            ? CropPage()
                            : FertilizerPage(),
                  ),
                );
              }),
              _cardImageHorizontalList(limitedItems),
            ],
          ),
        );
      }
    });
    if (sections.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text('No results found', style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }
    return Column(children: sections);
  }

  static Widget _buildCategory(String image, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFE5F5EC), shape: BoxShape.circle),
            child: Image.asset(image, width: 30, height: 30),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }

  static Widget _sectionHeader(String title, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          InkWell(
            onTap: onTap,
            child: const Row(
              children: [
                Text("See All", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _cardImageHorizontalList(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 168,
            height: 175,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: item['imageTop'] ?? 8.0,
                  left: item['imageLeft'] ?? 0.0,
                  child: Transform.rotate(
                    angle: (item['rotation'] ?? 0) * math.pi / 180,
                    child: Image.network(
                      item['img'],
                      width: item['imageWidth'],
                      height: item['imageHeight'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/${item['category'].toLowerCase()}/${item['id']}');
                    },
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}