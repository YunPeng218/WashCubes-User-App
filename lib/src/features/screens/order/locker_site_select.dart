import 'dart:convert';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/locker_compartment_select.dart';
import 'package:device_run_test/src/features/screens/order/order_screen.dart';
import 'package:device_run_test/src/common_widgets/cancel_confirm_alert.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';

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

  void handleBackButtonPress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CancelConfirmAlert(
            title: 'Warning',
            content:
                'You will be redirected to the Order Page. Do you want to proceed?',
            onPressedConfirm: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OrderPage()),
              );
            },
            cancelButtonText: 'Cancel',
            confirmButtonText: 'Confirm');
      },
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Drop Off Site',
                style: CTextTheme.blueTextTheme.displayLarge,
              ),
              const SizedBox(
                height: cDefaultSize * 0.5,
              ),
              Text(
                'Select the locker site where you will drop off your laundry.',
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
                              await handleLockerSiteSelection(
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
