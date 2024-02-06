import 'package:device_run_test/src/constants/sizes.dart';
import 'package:flutter/material.dart';

class FAQsPage extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      'question': 'How does the WashCubes works?',
      'answer': 'Scan QR on the locker and select the service you want service.'
    },
    {
      'question': 'What are the benefits of the service?',
      'answer': 'It is convenient and hygiene'
    },
    {
      'question': 'Is my laundry safe in lockers?',
      'answer': 'Yes, we have installed CCTV at every locker location.'
    },
    {
      'question': 'Is the service hygienic?',
      'answer': 'Yes, our smart laundry lockers are equipped with UV sterilization technology, primarily designed to sanitize the locker compartment. This feature helps eliminate germs, bacteria, and odours, ensuring that the environment your clothes are stored in is clean and safe.'
          '\n\nThe UV sterilization primarily targets the locker compartment, indirectly boosting the cleanliness of your clothes. You’ll get back fresh, sanitized garments, making your whole laundry experience more hygienic.'
    },
    // Add other FAQs here
  ];

  FAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs', style: Theme.of(context).textTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize - 10),
        child: ListView(
          children: faqData.map<Widget>((faq) {
            return ExpansionTile(
              title: Text(faq['question']!, style: Theme.of(context).textTheme.headlineMedium,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(faq['answer']!, style: Theme.of(context).textTheme.labelLarge,),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
