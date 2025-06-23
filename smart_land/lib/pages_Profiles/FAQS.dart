import 'package:flutter/material.dart';

class FactsPage extends StatelessWidget {
  const FactsPage({super.key});

  final List<Map<String, String>> facts = const [
    {
      'question': 'What is organic fertilizer? Is it better than chemical fertilizer?',
      'answer': 'It’s made from natural waste. It’s eco-friendly and safer for soil.'
    },
    {
      'question': 'How can I control pests without using chemicals?',
      'answer': 'Use organic methods, beneficial insects, or pest-repelling plants.'
    },
    {
      'question': 'Which crops need less water?',
      'answer': 'Olive, thyme, wheat, and leafy greens like lettuce.'
    },
    {
      'question': 'What is the best fertilizer for growing wheat?',
      'answer': 'Wheat needs fertilizer with nitrogen, like urea. You can also use NPK 20-20-20 for better growth.'
    },
    {
      'question': 'What are the best agricultural crops in Egypt?',
      'answer': 'Egypt’s best crops include wheat, rice, corn, cotton, sugarcane, and vegetables like tomatoes and onions.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'FAQS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, 
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: facts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final item = facts[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ${item['question']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  item['answer']!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, 
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          //يا خالد ممكن تتنقل للصفحات التانية حسب الأيقونات
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/all');
          if (index == 2) Navigator.pushNamed(context, '/analysis');
          if (index == 3) Navigator.pushNamed(context, '/chat');
          if (index == 4) Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.science_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}