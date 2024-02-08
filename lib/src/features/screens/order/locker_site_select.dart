import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/locker_compartment_select.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';

import 'package:device_run_test/src/constants/colors.dart';

class LockerSiteSelect extends StatefulWidget {
  @override
  _LockerSiteSelectState createState() => _LockerSiteSelectState();
}

class _LockerSiteSelectState extends State<LockerSiteSelect> {
  List<LockerSite> lockerSites = [];

  @override
  void initState() {
    super.initState();
    fetchLockerSites();
  }

  Future<void> fetchLockerSites() async {
    try {
      var reqUrl = url + 'lockers';
      final response = await http.get(Uri.parse(reqUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('lockers')) {
          final List<dynamic> lockerData = data['lockers'];
          final List<LockerSite> fetchedLockerSites =
              lockerData.map((site) => LockerSite.fromJson(site)).toList();
          setState(() {
            lockerSites = fetchedLockerSites;
          });
        } else {
          print('No lockers found.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load locker sites');
      }
    } catch (error) {
      print('Error fetching locker sites: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Locker Site',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderPage(),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: lockerSites.length,
        itemBuilder: (context, index) {
          return LockerSiteOption(
              title: lockerSites[index].name,
              icon: Icons.location_on,
              onTap: () async {
                await handleLockerSiteSelection(lockerSites[index]);
              });
        },
      ),
    );
  }

  // HANDLE LOCKER SITE SELECTION
  Future<void> handleLockerSiteSelection(LockerSite selectedLockerSite) async {
    // Store the selected locker site in the app's state or perform other actions
    print('Selected Locker Site: ${selectedLockerSite.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LockerCompartmentSelect(selectedLockerSite: selectedLockerSite),
      ),
    );
  }
}

class LockerSiteOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const LockerSiteOption(
      {Key? key, required this.title, required this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(icon, color: AppColors.cBlueColor4),
          title: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
