import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/config.dart';

class UserHelper {
  late String token;

  //GET ALL USER DETAILS
  Future<UserProfile?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = (await prefs.getString('token')) ?? 'No token';
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    String userId = jwtDecodedToken['_id'];

    // Request user details from server
    final response = await http.get(Uri.parse(url + 'user?userId=$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('user')) {
        final dynamic userData = data['user'];
        final UserProfile? user = UserProfile.fromJson(userData);
        return user;
      }
    }
    return null;
  }

  // GET USER ID AND PHONE NUM ONLY
  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user;
    token = (await prefs.getString('token')) ?? 'No token';
    if (token != 'No token') {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      user = User(
          id: jwtDecodedToken['_id'],
          phoneNumber: jwtDecodedToken['phoneNumber']);
    } else {
      user = null;
    }
    return user;
  }

  // CHECK IF USER IS SIGNED IN
  Future<bool> isSignedIn() async {
    User? user = await getUser();
    return (user != null);
  }
}
