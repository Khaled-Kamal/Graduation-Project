import 'package:flutter/material.dart';
import 'package:smart_land/Screens/Login%20Options.dart';

import 'package:smart_land/components/onboord_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final Controller = onBoardingData();
  final pageController = PageController();
  int cur = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            body(),
            buildDots(),
            Button(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  // body
  Widget body() {
    return Expanded(
      child: Center(
        child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                cur = value;
              });
            },
            itemCount: Controller.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Controller.items[cur].Image),
                    Text(
                      Controller.items[cur].title,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        Controller.items[cur].Description,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
  // Dots

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        Controller.items.length,
        (index) => AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: cur == index ?  Color(0xFF2E7D32) : Colors.grey,
          ),
          height: 7.0,
          width: cur == index ? 30 : 10,
          duration: Duration(milliseconds: 700),
        ),
      ),
    );
  }
 //Button
Widget Button() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    height: 55,
    width: MediaQuery.of(context).size.width * .9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Color(0xFF2E7D32),
    ),
    child: TextButton(
      onPressed: () {
        setState(() {
          if (cur != Controller.items.length - 1) {
            cur++;
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeSelectionPage()),
            );
          }
        });
      },
      child: Text(
        cur == Controller.items.length - 1 ? "Get started" : "Continue",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
}
