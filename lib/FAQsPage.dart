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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //     context,
        //         MaterialPageRoute(builder: (context) => const SettingMainPage()),
        //   },
        // ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,s
      ),
      body: ListView(
        children: faqData.map<Widget>((faq) {
          return ExpansionTile(
            title: Text(faq['question']!),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(faq['answer']!),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
