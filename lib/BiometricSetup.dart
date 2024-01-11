import 'package:flutter/material.dart';
import 'HomePage.dart';

class BiometricSetup extends StatelessWidget {
  const BiometricSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Log In', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()),
              );}, 
              child: 
              const Text('Skip', style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline),),
            ),
            SizedBox(height: 40.0),
            Text('Enabling TouchID or Face ID will give you faster access.', textAlign: TextAlign.center,),
            SizedBox(height: 40.0),
            
          ],
        ),
      ),

    );
  }
}