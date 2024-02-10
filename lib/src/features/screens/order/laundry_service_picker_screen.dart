// ignore_for_file: use_build_context_synchronously

import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:device_run_test/src/constants/image_strings.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/screens/order/select_item_screen.dart';
import 'package:device_run_test/src/features/screens/order/locker_compartment_select.dart';

import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/common_widgets/cancel_confirm_alert.dart';

class LaundryServicePicker extends StatefulWidget {
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;
  final String? selectedCompartmentSize;

  LaundryServicePicker(
      {required this.lockerSite,
      required this.compartment,
      this.selectedCompartmentSize});

  @override
  _LaundryServicePickerState createState() => _LaundryServicePickerState();
}

class _LaundryServicePickerState extends State<LaundryServicePicker> {
  List<Service> services = [];

  Map<String, String> serviceImages = {
    'Wash & Fold': cWashAndFold,
    'Dry Cleaning': cDryCleaning,
    'Laundry & Iron': cLaundryAndIron,
    'Ironing': cIroning,
    'Handwash': cHandwash,
  };

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
            compartment: widget.compartment,
            selectedCompartmentSize: widget.selectedCompartmentSize,
            service: selectedService),
      ),
    );
  }

  void handleBackButtonPress() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //Alert Dialog PopUp of Backtrack Confirmation
        return CancelConfirmAlert(
            title: 'Warning',
            content:
                'Are you sure you want to go back? Any assigned compartments will be released.',
            onPressedConfirm: freeUpLockerCompartment,
            cancelButtonText: 'Cancel',
            confirmButtonText: 'Confirm');
      },
    );
  }

  void freeUpLockerCompartment() async {
    if (widget.compartment != null) {
      try {
        Map<String, dynamic> compartmentToRelease = {
          'lockerSiteId': widget.lockerSite?.id,
          'compartmentId': widget.compartment?.id,
        };

        final response = await http.post(
          Uri.parse(url + 'locker/release-compartment'),
          body: json.encode(compartmentToRelease),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LockerCompartmentSelect(
                      selectedLockerSite: widget?.lockerSite,
                    )),
          );
        } else {
          throw Exception('Failed to release compartment');
        }
      } catch (error) {
        print('Error releasing compartment: $error');
      }
    } else {
      // Navigate back if compartment is null
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LockerCompartmentSelect(
                  selectedLockerSite: widget?.lockerSite,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: handleBackButtonPress,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Pick Laundry Service',
              style: CTextTheme.blueTextTheme.displayLarge,
            ),
            const SizedBox(
              height: cDefaultSize * 0.5,
            ),
            Text(
              'Note: Only one service is available for a single order.',
              style: CTextTheme.blackTextTheme.headlineSmall,
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
                        iconName: serviceImages[service.name]!,
                        onTap: () {
                          handleServiceSelection(service);
                        },
                      );
                    }))),
          ]),
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
                style: CTextTheme.blackTextTheme.headlineLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
