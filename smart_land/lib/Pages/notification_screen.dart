import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadAuthTokenAndFetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications available'));
          }
          final notifications = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      item['isRead'] ? 'assets/recommended crop.png' : 'assets/fertilizer_noti.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(
                  item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item['message'],
                    style: const TextStyle(height: 1.3, fontSize: 13, color: Colors.black87),
                  ),
                ),
                trailing: Text(
                  _formatTimeAgo(item['createdAt']),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadAuthTokenAndFetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken == null) {
      throw Exception('No authentication token found. Please log in.');
    }

    try {
      final response = await _dio.get(
        'https://48pmt2mt-7016.uks1.devtunnels.ms/api/Notifications',
        options: Options(
          validateStatus: (status) {
            return status! < 500; // Accept status codes below 500
          },
          headers: {'Authorization': 'Bearer $authToken'}, // Move headers inside options
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return List<Map<String, dynamic>>.from(data['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please check your authentication token.');
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Error fetching notifications: ${e.message}');
      }
      throw Exception('Error fetching notifications: $e');
    }
  }

  String _formatTimeAgo(String createdAt) {
    DateTime dateTime = DateTime.parse(createdAt);
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d Ago';
    if (difference.inHours > 0) return '${difference.inHours}h Ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m Ago';
    return 'Just now';
  }
}