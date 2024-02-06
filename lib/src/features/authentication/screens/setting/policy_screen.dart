import 'package:device_run_test/src/constants/sizes.dart';
import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: Theme.of(context).textTheme.displaySmall,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Text(
          // Replace with actual privacy policy text
          'Lorem ipsum dolor sit amet, quo aperiores inventore et eum maxime est necessitatibus voluptates molestias animi. Et ab voluptatem delicti et quos possimus non tosto. Nunc magnam, quos interdum molestiae non dolor assumenda non ipsa pariatur et consequatur vitae sed numquam eius!\n\n'
          // ... Continue with the rest of the privacy policy text
              'Lorem ipsum dolor sit amet, quo aperiores inventore et eum maxime est necessitatibus...',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
