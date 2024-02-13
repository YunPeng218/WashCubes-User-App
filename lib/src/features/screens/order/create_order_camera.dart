import 'package:device_run_test/src/features/screens/order/locker_site_select.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/models/locker.dart';
import 'package:device_run_test/src/features/screens/order/locker_compartment_select.dart';

class CreateOrderCameraPage extends StatefulWidget {
  const CreateOrderCameraPage({super.key});

  @override
  _CreateOrderCameraPageState createState() => _CreateOrderCameraPageState();
}

class _CreateOrderCameraPageState extends State<CreateOrderCameraPage> {
  String? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool navigationCompleted = false;
  bool isLightOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar Title
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Place the QR Code within the frame to scan',
            style: CTextTheme.blackTextTheme.headlineMedium,
          ),
          const SizedBox(height: 10.0),
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _toggleLight,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.yellow[100]!)),
                child: Text(
                  'Turn on Lights',
                  style: CTextTheme.blackTextTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockerSiteSelect(),
                    ),
                  );
                },
                child: Text(
                  'Select Manually',
                  style: CTextTheme.blackTextTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  //Light Activation Function
  void _toggleLight() {
    controller?.toggleFlash();
    setState(() {
      isLightOn = !isLightOn;
    });
  }

  // GET LOCKER INFORMATION FROM QR CODE
  Future<LockerSite?> fetchLockerData(String? url) async {
    try {
      if (url != null) {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return LockerSite.fromJson(jsonResponse['locker']);
        } else {
          print('Request failed with status: ${response.statusCode}');
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching data: $error');
      return null;
    }
  }

  //QR Code Scanner Function
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) async {
        setState(() {
          result = scanData.code;
        });
        if (result != null && !navigationCompleted) {
          navigationCompleted = true;
          if (isLightOn) _toggleLight();
          LockerSite? locker = await fetchLockerData(result);
          if (locker != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LockerCompartmentSelect(selectedLockerSite: locker),
              ),
            );
          } else {
            print('Error Reading QR Code.');
          }
        }
      },
      onError: (error) {
        print('Error in scannedDataStream: $error');
      },
      onDone: () {
        print('scannedDataStream is done');
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
