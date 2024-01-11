import '../../../../../OTPVerifyPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'LoginPage.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Sign Up Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 29),
              constraints: const BoxConstraints (maxWidth:  301),
              child: const Text('Kindly provide your mobile number, and a verification OTP will sent to your mobile number via SMS or WhatsApp.'),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 220, 12),
              child: const Text('MOBILE NUMBER', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ),
            Container(
              margin:  const EdgeInsets.fromLTRB(50, 0, 0, 20),
              // width:  double.infinity,
              // height:  50,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Country Phone Code
                  Container(
                    width:  70,
                    height:  40,
                    decoration:  BoxDecoration (
                      border:  Border.all(color: Color(0xFF000000)),
                      borderRadius:  BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('MY +60',textAlign: TextAlign.center),
                    ),
                  ),
                  //Phone No. Input Box
                  Container(
                    width:  200,
                    height:  40,
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.fromLTRB(5, 17, 0, 0),
                    decoration:  BoxDecoration (
                      border:  Border.all(color: Color(0xFFD7ECF7)),
                      borderRadius:  BorderRadius.circular(10),
                    ),
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      decoration: const InputDecoration(
                        hintText:'12-345 6789', 
                        hintStyle: TextStyle(color: Colors.grey), 
                        counterText: '',
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Send OTP Button
            TextButton(
              onPressed: () {Navigator.push(
                    context, MaterialPageRoute(builder: (context) => OTPVerifyPage(source: 'signup')),
                  );},// Send to OTP Page
              child: Container(
                width:  300,
                height:  46,
                // margin: EdgeInsets.only(top: 50.0),
                decoration:  BoxDecoration (
                  color: Color(0xFFD7ECF7),
                  //border:  Border.all(color: Colors.black),
                  borderRadius:  BorderRadius.circular(10),
                  boxShadow:  const [
                    BoxShadow(
                      color:  Color(0x3f000000),
                      offset:  Offset(0, 2),
                      blurRadius:  2,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send OTP', 
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 8), 
                    Icon(Icons.send_rounded, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}