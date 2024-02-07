import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/screens/home/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/screens/order/select_item_screen.dart';

import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';

class LaundryServicePicker extends StatefulWidget {
  final LockerSite lockerSite;
  //final LockerCompartment? compartment;
  final String selectedCompartmentSize;

  LaundryServicePicker(
      {required this.lockerSite, required this.selectedCompartmentSize});

  @override
  _LaundryServicePickerState createState() => _LaundryServicePickerState();
}

class _LaundryServicePickerState extends State<LaundryServicePicker> {
  List<Service> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  // GET SERVICES FROM BACKEND
  Future<void> fetchServices() async {
    try {
      final response = await http.get(Uri.parse(url + 'services'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('services')) {
          final List<dynamic> serviceData = data['services'];
          final List<Service> fetchedServices =
              serviceData.map((service) => Service.fromJson(service)).toList();
          setState(() {
            services = fetchedServices;
          });
        } else {
          print('Response data does not contain services.');
        }
      } else {
        throw Exception('Failed to load services');
      }
    } catch (error) {
      print('Error fetching services: $error');
    }
  }

  // HANDLE SERVICE SELECTION FROM USER
  void handleServiceSelection(Service selectedService) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectItems(
            lockerSite: widget.lockerSite,
            selectedCompartmentSize: widget.selectedCompartmentSize,
            service: selectedService),
      ),
    );
  }

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Pick your Laundry Service',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: cDefaultSize * 0.5,
          ),
          Text(
            'Note: Only one service is available for a single order.',
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
                  children: List.generate(services.length, (index) {
                    final service = services[index];
                    return ServiceCard(
                      serviceName: service.name,
                      iconName:
                          'assets/images/laundry_service/${service.name.replaceAll(' ', '')}.png',
                      onTap: () {
                        handleServiceSelection(service);
                      },
                    );
                  }))),
        ]),
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
