import 'package:device_run_test/src/features/screens/order/locker_site_select.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CreateOrderCameraPage extends StatefulWidget {
  const CreateOrderCameraPage({super.key});

  @override
  _CreateOrderCameraPageState createState() => _CreateOrderCameraPageState();
}

class _CreateOrderCameraPageState extends State<CreateOrderCameraPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
          ElevatedButton(
            //onPressed: _turnOnLight,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LockerSiteSelect()),
              );
            },
            child: Text(
              'Tap to turn light on',
              style: CTextTheme.blackTextTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  //Light Activation Function
  void _turnOnLight() {
    controller?.toggleFlash();
  }

  //QR Code Scanner Function
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    print('CALLED');
    controller.scannedDataStream.listen(
      (scanData) {
        print('CALLED2: $scanData');
        setState(() {
          result = scanData;
        });
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
