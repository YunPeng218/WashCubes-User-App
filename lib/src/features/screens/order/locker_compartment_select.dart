import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/laundry_service_picker_screen.dart';
import 'package:device_run_test/src/features/screens/order/locker_site_select.dart';

class LockerCompartmentSelect extends StatefulWidget {
  final LockerSite selectedLockerSite;
  LockerCompartmentSelect({required this.selectedLockerSite});
  @override
  _LockerCompartmentSelectState createState() =>
      _LockerCompartmentSelectState();
}

class _LockerCompartmentSelectState extends State<LockerCompartmentSelect> {
  LockerAvailabilityResponse? availableCompartments;
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

          // if (availableCompartments?.availableCompartmentsBySize.isEmpty ??
          //     true) {
          //   // Do something if availableCompartmentsBySize is empty
          //   isLockerSiteFull = true;
          // }
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaundryServicePicker(
          lockerSite: widget.selectedLockerSite,
          selectedCompartmentSize: selectedSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> compartmentSizes = ['Small', 'Medium', 'Large', 'Extra Large'];

    // SHOW DIALOG IF LOCKER SITE IS FULL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (availableCompartments?.availableCompartmentsBySize.isEmpty ?? true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Available Compartments'),
              content: Text(
                  'Sorry, there are no available compartments for any size. Please select another locker site.'),
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
                  child: Text('Go Back'),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Locker Size'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: compartmentSizes.length,
          itemBuilder: (context, index) {
            final compartmentSize = compartmentSizes[index];
            final compartments = availableCompartments
                    ?.availableCompartmentsBySize[compartmentSize] ??
                0;

            return ListTile(
              title: Text(compartmentSizes[index]),
              subtitle: Text('Available Compartments: ${compartments}'),
              trailing: ElevatedButton(
                onPressed: () async {
                  await handleSelection(compartmentSizes[index]);
                },
                child: Text('Select'), // Customize the button text
              ),
            );
          },
        ),
      ),
    );
  }
}
