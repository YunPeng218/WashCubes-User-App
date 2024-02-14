import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'nearby_location_page.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/nearbylocation/locker_site_details.dart';

class NearbyLocationsScreen extends StatefulWidget {
  final List<LockerSite> lockerSites;
  final LatLng? currentLocation;
  final Map<String, int> lockerSiteAvailabilities;
  const NearbyLocationsScreen(
      {super.key,
      required this.lockerSites,
      required this.currentLocation,
      required this.lockerSiteAvailabilities});

  @override
  _NearbyLocationsScreenState createState() => _NearbyLocationsScreenState();
}

class _NearbyLocationsScreenState extends State<NearbyLocationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  double calculateDistance(LockerSite lockerSite) {
    if (widget.currentLocation != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
        lockerSite.location.coordinates[1],
        lockerSite.location.coordinates[0],
      );
      return distanceInMeters / 1000;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nearby Locker Sites",
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NearbyLocationPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.lockerSites.length,
                itemBuilder: (context, index) {
                  LockerSite lockerSite = widget.lockerSites[index];
                  double distance = calculateDistance(lockerSite);
                  return Card(
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: Image.asset(cAppLogo, width: 60, height: 60),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lockerSite.name,
                            style: CTextTheme.blackTextTheme.headlineLarge,
                          ),
                          Text('${distance.toStringAsFixed(2)} KM',
                              style: CTextTheme.blackTextTheme.headlineSmall),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Compartments: ${widget.lockerSiteAvailabilities[lockerSite.id] ?? 0}',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ),
                          Row(
                            children: [
                              widget.lockerSiteAvailabilities[lockerSite.id] ==
                                      0
                                  ? Text(
                                      'Full',
                                      style:
                                          CTextTheme.redTextTheme.headlineSmall,
                                    )
                                  : Text(
                                      'Available',
                                      style: CTextTheme
                                          .greenTextTheme.headlineSmall,
                                    ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LockerSiteDetailsPopup(
                              lockerSite: lockerSite,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NearbyLocationPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Back to Map',
                            style: CTextTheme.blackTextTheme.headlineMedium,
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
