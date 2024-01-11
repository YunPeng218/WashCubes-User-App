import 'package:device_run_test/src/constraints/image_strings.dart';
import 'package:device_run_test/src/constraints/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:device_run_test/src/constraints/colors.dart';
// import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              OnboardingPage(imagePath: cOnboardingImage1, title: cOnboardingTitle1, subtitle: cOnboardingSubtitle1, currentIndex: _currentPage,),
              OnboardingPage(imagePath: cOnboardingImage2, title: cOnboardingTitle2, subtitle: cOnboardingSubtitle2, currentIndex: _currentPage,),
              OnboardingPage(imagePath: cOnboardingImage3, title: cOnboardingTitle3, subtitle: cOnboardingSubtitle3, currentIndex: _currentPage,),
            ],
          ),),
          Padding(
            padding: const EdgeInsets.fromLTRB(250.0, 0, 0, 70.0),
            child: Align(
              alignment: Alignment.center,
              child: _currentPage < 2 ?IconButton(
                icon: const Icon(
                  Icons.arrow_forward, size: 40.0,
                ), 
                onPressed: () {
                  if (_currentPage < 2) {
                    // Advance to the next page
                    _pageController.animateToPage(
                      _currentPage + 1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
              ): ElevatedButton(
                onPressed: () {
                  // Handle the action for the button on the last page
                  // You can navigate to the next screen or perform any other action
                },
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.fromLTRB(70, 0, 70,0),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: AppColors.cButtonColor,
                ),
                child: Text('Start'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final int currentIndex;

  const OnboardingPage({required this.imagePath, required this.title, required this.subtitle, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image(image: AssetImage(imagePath),),
        DotsIndicator(itemCount: 3, currentIndex: currentIndex),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 15.0),
          child: Text(title, style: Theme.of(context).textTheme.displayMedium,),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
          child: Text(subtitle, style: Theme.of(context).textTheme.headlineSmall,),
        ),
      ],
    );
  }
}

class DotsIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  DotsIndicator({required this.itemCount, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}

