// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './nearby_location_list.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/features/screens/nearbylocation/locker_site_details.dart';

class NearbyLocationPage extends StatefulWidget {
  const NearbyLocationPage({super.key});

  @override
  NearbyLocationPageState createState() => NearbyLocationPageState();
}

class NearbyLocationPageState extends State<NearbyLocationPage> {
  GoogleMapController? mapController;
  bool _infoWindowOpen = false;
  LatLng? currentLocation;
  bool isLocationLoading = true;
  bool isLockerSitesLoading = true;
  List<LockerSite> lockerSites = [];
  late BitmapDescriptor userMarker;
  late BitmapDescriptor lockerMarker;
  final Map<String, int> lockerSiteAvailabilities = new Map<String, int>();

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    initCustomMarkers();
    getCurrentLocation();
    fetchLockerSites();
  }

  void initCustomMarkers() async {
    userMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), cTrimiBig);
    lockerMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), cAppLogo);
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      getCurrentLocation();
    } else {
      print('NO LOCATION FOR YOU!');
    }
  }

  Future<void> getCurrentLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );
    print(currentLocation);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      isLocationLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> fetchLockerSites() async {
    try {
      var reqUrl = '${url}lockers';
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
          lockerSites.forEach((lockerSite) async {
            int? availableCompartments =
                await fetchAvailableCompartments(lockerSite);
            if (availableCompartments != null) {
              lockerSiteAvailabilities.putIfAbsent(
                  lockerSite.id, () => availableCompartments);
            }
          });
        } else {
          print('No lockers found.');
        }
      } else {
        throw Exception('Failed to load locker sites');
      }
    } catch (error) {
      print('Error fetching locker sites: $error');
    }
  }

  Future<int?> fetchAvailableCompartments(LockerSite? lockerSite) async {
    try {
      final response = await http
          .get(Uri.parse('${url}compartments?lockerSiteId=${lockerSite?.id}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('availableCompartments')) {
          final dynamic compartmentData = data['availableCompartments'];
          final LockerAvailabilityResponse compartments =
              LockerAvailabilityResponse.fromJson(compartmentData);

          int availableCompartments = 0;
          compartments.availableCompartmentsBySize.forEach((size, count) {
            availableCompartments += count;
          });
          return availableCompartments;
        } else {
          print('Response data does not locker compartments.');
          return null;
        }
      } else {
        throw Exception('Failed to locker compartments.');
      }
    } catch (error) {
      print('Error fetching available compartments: $error');
      return null;
    }
  }

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};
    lockerSites.forEach((lockerSite) {
      markers.add(
        Marker(
          markerId: MarkerId(lockerSite.id),
          position: LatLng(lockerSite.location.coordinates[1],
              lockerSite.location.coordinates[0]),
          icon: lockerMarker,
          infoWindow: InfoWindow(
              title: lockerSite.name,
              snippet:
                  'Available Compartments: ${lockerSiteAvailabilities[lockerSite.id]}',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LockerSiteDetailsPopup(
                      lockerSite: lockerSite,
                    );
                  },
                );
              }),
        ),
      );
    });
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation!,
          icon: userMarker,
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
        ),
      );
    }
    return markers;
  }

  void moveToCurrentLocation() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation!,
          zoom: 11.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Locker Site Locations',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _infoWindowOpen = !_infoWindowOpen;
                });
                moveToCurrentLocation();
              },
              backgroundColor: AppColors.cBarColor,
              mini: true,
              child: const Icon(
                Icons.my_location,
                color: AppColors.cWhiteColor,
              ),
            ),
          ),
        ],
      ),
      body: isLocationLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: currentLocation!,
                    zoom: 13.0,
                  ),
                  markers: createMarkers(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NearbyLocationsScreen(
                                      lockerSites: lockerSites,
                                      currentLocation: currentLocation,
                                      lockerSiteAvailabilities:
                                          lockerSiteAvailabilities,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.cBarColor),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.list,
                                    color: Colors.white,
                                  ), // Add the list icon
                                  const SizedBox(width: 5),
                                  Text(
                                    'List',
                                    style: CTextTheme
                                        .whiteTextTheme.headlineMedium,
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class LockerInfoCard extends StatefulWidget {
  final LockerSite? lockerSite;

  const LockerInfoCard({super.key, required this.lockerSite});

  @override
  LockerInfoCardState createState() => LockerInfoCardState();
}

class LockerInfoCardState extends State<LockerInfoCard> {
  int availableCompartments = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchAvailableCompartments() async {
    try {
      final response = await http.get(Uri.parse(
          '${url}compartments?lockerSiteId=${widget.lockerSite?.id}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('availableCompartments')) {
          final dynamic compartmentData = data['availableCompartments'];
          final LockerAvailabilityResponse compartments =
              LockerAvailabilityResponse.fromJson(compartmentData);

          compartments.availableCompartmentsBySize.forEach((size, count) {
            availableCompartments += count;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.lockerSite?.name ?? 'Loading...'),
      ],
    );
  }
}
