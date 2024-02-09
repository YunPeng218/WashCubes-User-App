import 'dart:convert';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/models/service.dart';
import 'package:device_run_test/src/features/models/order.dart';
import 'package:device_run_test/src/features/screens/order/order_summary_screen.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';

class CollectionSiteSelect extends StatefulWidget {
  final LockerSite? lockerSite;
  final LockerCompartment? compartment;
  final String? selectedCompartmentSize;
  final Service? service;
  final Order? order;

  const CollectionSiteSelect({
    super.key,
    required this.lockerSite,
    required this.compartment,
    required this.selectedCompartmentSize,
    required this.service,
    required this.order,
  });

  @override
  CollectionSiteSelectState createState() => CollectionSiteSelectState();
}

class CollectionSiteSelectState extends State<CollectionSiteSelect> {
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

  // HANDLE LOCKER SITE SELECTION
  Future<void> handleCollectionSiteSelection(
      LockerSite selectedLockerSite) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderSummary(
              lockerSite: widget.lockerSite,
              compartment: widget.compartment,
              selectedCompartmentSize: widget.selectedCompartmentSize,
              service: widget.service,
              order: widget.order,
              collectionSite: selectedLockerSite)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Order Collection Site',
                style: CTextTheme.blueTextTheme.displayLarge,
              ),
              const SizedBox(
                height: cDefaultSize * 0.5,
              ),
              Text(
                'Select the locker site where your laundry will be returned.',
                style: CTextTheme.blackTextTheme.headlineSmall,
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                itemCount: lockerSites.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: LockerSiteOption(
                            title: lockerSites[index].name,
                            icon: Icons.location_on,
                            onTap: () async {
                              await handleCollectionSiteSelection(
                                  lockerSites[index]);
                            }),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
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
          leading: Icon(icon, color: AppColors.cBlueColor3),
          title: Text(
            title,
            style: CTextTheme.blackTextTheme.headlineMedium,
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
