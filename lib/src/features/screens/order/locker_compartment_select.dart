// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/laundry_service_picker_screen.dart';
import 'package:device_run_test/src/features/screens/order/locker_site_select.dart';

// UTILS
import 'package:device_run_test/src/utilities/guest_mode.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';

// CONSTANTS
import 'package:device_run_test/src/constants/sizes.dart';

class LockerCompartmentSelect extends StatefulWidget {
  final LockerSite selectedLockerSite;
  LockerCompartmentSelect({required this.selectedLockerSite});
  @override
  _LockerCompartmentSelectState createState() =>
      _LockerCompartmentSelectState();
}

class _LockerCompartmentSelectState extends State<LockerCompartmentSelect> {
  LockerAvailabilityResponse? availableCompartments;
  LockerCompartment? assignedCompartment;
  // bool isLockerSiteFull = false;

  void initState() {
    super.initState();
    fetchAvailableCompartments();
  }

  Future<void> fetchAvailableCompartments() async {
    try {
      final response = await http.get(Uri.parse(
          url + 'compartments?lockerSiteId=${widget.selectedLockerSite.id}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('availableCompartments')) {
          final dynamic compartmentData = data['availableCompartments'];
          final LockerAvailabilityResponse compartments =
              LockerAvailabilityResponse.fromJson(compartmentData);
          setState(() {
            availableCompartments = compartments;
          });
        } else {
          print('Response data does not locker compartments.');
        }
      } else {
        throw Exception('Failed to locker compartments.');
      }
    } catch (error) {
      print('Error fetching available compartments: $error');
    }
  }

  Future<void> handleSelection(String selectedSize) async {
    print(widget.selectedLockerSite);
    print(selectedSize);

    var userHelper = UserHelper();
    bool isSignedIn = await userHelper.isSignedIn();

    if (isSignedIn) {
      // GET COMPARTMENT FOR SIGNED IN USER
      assignedCompartment = await assignCompartment(selectedSize);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaundryServicePicker(
            lockerSite: widget.selectedLockerSite,
            compartment: assignedCompartment,
            selectedCompartmentSize: null,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaundryServicePicker(
            lockerSite: widget.selectedLockerSite,
            compartment: null,
            selectedCompartmentSize: selectedSize,
          ),
        ),
      );
    }
  }

  // GET COMPARTMENT FOR SIGNED IN USER
  Future<LockerCompartment?> assignCompartment(String selectedSize) async {
    try {
      final response = await http.post(
        Uri.parse(url + 'orders/select-locker-site'),
        body: json.encode({
          'selectedLockerSiteId': widget.selectedLockerSite.id,
          'selectedSize': selectedSize,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey('allocatedCompartment')) {
          final dynamic compartmentData = data['allocatedCompartment'];
          return LockerCompartment.fromJson(compartmentData);
        } else {
          print('No available compartments found.');
        }
      } else if (response.statusCode == 404) {
        print('Error Retrieving Available Compartment');
      }
    } catch (error) {
      print('Error sending selected locker site: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<String> compartmentSizes = ['Small', 'Medium', 'Large', 'Extra Large'];
    List<String> compartmentDimensions = ['315mm', '472.5mm', '630mm', '945mm'];

    // SHOW DIALOG IF LOCKER SITE IS FULL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (availableCompartments?.availableCompartmentsBySize.isEmpty ?? false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Available Compartments', style: CTextTheme.blackTextTheme.headlineMedium,),
              content: Text(
                'Sorry, there are no available compartments for any size. Please select another locker site.',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LockerSiteSelect(),
                      ),
                    );
                  },
                  child: Text('Go Back', style: CTextTheme.blackTextTheme.headlineSmall,),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: Column(
          children: [
            Text(
              'Select Your Compartment Size',
              style: CTextTheme.blackTextTheme.displayLarge,
            ),
            const SizedBox(
              height: cDefaultSize * 0.5,
            ),
            Provider.of<GuestModeProvider>(context, listen: false).guestMode
                ? Text(
                    'Note For Guests: Locker compartment will only be assigned to you after and sign in and is subject to availability.',
                    style: CTextTheme.blackTextTheme.headlineSmall,
                  )
                : const SizedBox(
                    height: cDefaultSize,
                  ),
            const SizedBox(height: cDefaultSize),
            GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                shrinkWrap: true,
                children: List.generate(compartmentSizes.length, (index) {
                  final compartmentSize = compartmentSizes[index];
                  final compartments = availableCompartments
                          ?.availableCompartmentsBySize[compartmentSize] ??
                      0;
                  return CompartmentCard(
                    compartmentSize: compartmentSize,
                    dimensions: compartmentDimensions[index],
                    compartmentsAvailable: compartments,
                    isFull: compartments == 0 ? true : false,
                    iconName: 'assets/images/laundry_service/Handwash.png',
                    onTap: () {
                      handleSelection(compartmentSizes[index]);
                    },
                  );
                })),
          ],
        ),
      ),
    );
  }
}

class CompartmentCard extends StatelessWidget {
  final String iconName;
  final String compartmentSize;
  final String dimensions;
  final int compartmentsAvailable;
  final VoidCallback onTap;
  final bool isFull;

  const CompartmentCard(
      {super.key,
      required this.iconName,
      required this.compartmentSize,
      required this.dimensions,
      required this.compartmentsAvailable,
      required this.onTap,
      required this.isFull});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: isFull ? null : onTap,
      child: Card(
        elevation: 2.0,
        color: isFull ? Colors.grey[400] : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(iconName, height: size.height * 0.1),
            Column(
              children: [
                Text(
                  compartmentSize,
                  style: CTextTheme.blackTextTheme.headlineLarge,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Dimension: $dimensions',
                  style: CTextTheme.blackTextTheme.labelMedium,
                ),
                const SizedBox(height: 6.0),
                isFull
                    ? Text(
                        'FULL',
                        style: CTextTheme.blackTextTheme.labelLarge,
                      )
                    : Text(
                        '$compartmentsAvailable COMPARTMENTS',
                        style: CTextTheme.blackTextTheme.labelLarge,
                      ),
                const SizedBox(height: 4.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
