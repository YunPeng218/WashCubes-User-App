import 'package:flutter/material.dart';

class OnboardingP1 extends StatelessWidget {
  const OnboardingP1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}
class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final int _numPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _numPages,
        itemBuilder: (BuildContext context, int index) {
          return OnboardingPage(index: index);
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final int index;

  OnboardingPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Set your desired background color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add your onboarding content, e.g., texts and images
          Text(
            'Page $index',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          SizedBox(height: 20.0),
          // Add other widgets as needed
        ],
      ),
    );
  }
}
