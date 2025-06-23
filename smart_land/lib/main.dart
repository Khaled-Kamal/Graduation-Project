import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:smart_land/Pages/all_category.dart';
import 'package:smart_land/Pages/chat.dart';
import 'package:smart_land/Pages/crop.dart';
import 'package:smart_land/Pages/fertilizer.dart';
import 'package:smart_land/Pages/filter_page.dart';
import 'package:smart_land/Pages/home_screen.dart';
import 'package:smart_land/Pages/notification_screen.dart';
import 'package:smart_land/Pages/plants.dart';
import 'package:smart_land/Pages/results_page.dart';
import 'package:smart_land/Pages/soil_analysis_page.dart';
import 'package:smart_land/Screens/AuthScreen.dart';
import 'package:smart_land/Screens/Splach.dart';

import 'package:smart_land/information/bamboo.dart';
import 'package:smart_land/information/manure.dart';
import 'package:smart_land/information/oats.dart';

import 'package:smart_land/pages_Profiles/ProfileScreen.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => SmartLandApp(),
    ),
  );
}

class SmartLandApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/chat': (context) => ChatPage(),
        '/analysis': (context) => SoilAnalysisPage(),
        '/filter': (context) => const FilterPage(),
        '/all': (context) => const AllCategory(),
        '/Crops': (context) => const CropPage(),
        '/Fertilizers': (context) => const FertilizerPage(),
        '/plants': (context) => const PlantsPage(),
        '/profile': (context) => const ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/plant/') == true) {
          final id = int.tryParse(settings.name!.split('/').last);
          if (id != null) {
            return MaterialPageRoute(
              builder: (context) => BambooPage(id: id),
            );
          }
        } else if (settings.name?.startsWith('/fertilizer/') == true) {
          final id = int.tryParse(settings.name!.split('/').last);
          if (id != null) {
            return MaterialPageRoute(
              builder: (context) => ManurePage(fertilizerId: id),
            );
          }
        } else if (settings.name?.startsWith('/crop/') == true) {
          final id = int.tryParse(settings.name!.split('/').last);
          if (id != null) {
            return MaterialPageRoute(
              builder: (context) => OatsPage(cropId: id),
            );
          }
        } else if (settings.name == '/result') {
          final args = settings.arguments as Map<String, dynamic>?;
          final results = args?['results'] as List<dynamic>? ?? [];
          return MaterialPageRoute(
            builder: (context) => ResultsPage(results: results),
          );
        }
        return null;
      },
    );
  }
}
