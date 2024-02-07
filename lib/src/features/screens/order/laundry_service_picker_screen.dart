import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';
import 'package:device_run_test/src/features/screens/order/select_item_screen.dart';
import 'package:flutter/material.dart';
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Laundry Service Picker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const LaundryServicePicker(),
//     );
//   }
// }

class LaundryServicePicker extends StatelessWidget {
  const LaundryServicePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     // Handle back button
          //   },
          // ),
          // title: const Text('Pick your Laundry Service'),
          // centerTitle: true,
          ),
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick your Laundry Service',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: cDefaultSize * 0.5,
            ),
            Text(
              'One service is available for a single order.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: cDefaultSize,
            ),
            //Laundry Service Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  ServiceCard(
                    serviceName: 'Wash & Fold',
                    iconName: 'assets/images/laundry_service/wash_and_fold.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  ServiceCard(
                    serviceName: 'Dry Cleaning',
                    iconName: 'assets/images/laundry_service/dry_cleaning.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectYourItemPage()),
                      );
                    },
                  ),
                  ServiceCard(
                    serviceName: 'Handwash',
                    iconName: 'assets/images/laundry_service/handwash.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectYourItemPage()),
                      );
                    },
                  ),
                  ServiceCard(
                    serviceName: 'Laundry & Iron',
                    iconName:
                        'assets/images/laundry_service/laundry_and_iron.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectYourItemPage()),
                      );
                    },
                  ),
                  ServiceCard(
                    serviceName: 'Ironing',
                    iconName: 'assets/images/laundry_service/ironing.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectYourItemPage()),
                      );
                    },
                  ),
                  // Assuming you have an icon for the chatbot as well
                  // ServiceCard(serviceName: 'Chat with Support', iconName: 'icons/support_chat.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Laundry Service Card Method
class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String iconName;
  final VoidCallback onTap;

  const ServiceCard(
      {super.key,
      required this.serviceName,
      required this.iconName,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(iconName,
                height: size.height *
                    0.1), // Replace with NetworkImage if your images are network-based
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                serviceName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
