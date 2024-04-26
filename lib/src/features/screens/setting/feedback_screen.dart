import 'dart:convert';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedbackRatingsPage extends StatefulWidget {
  const FeedbackRatingsPage({super.key});

  @override
  _FeedbackRatingsPageState createState() => _FeedbackRatingsPageState();
}

class _FeedbackRatingsPageState extends State<FeedbackRatingsPage> {
  double _rating = 5;
  final _improvementOptions = [
    'Overall Service',
    'Pick Up and Delivery Service',
    'Payment Process',
    'Speed & Efficiency',
    'Order Status Updates',
    'Customer Support'
  ];
  List<String> _selectedImprovements = [];
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback Ratings',
          style: CTextTheme.blackTextTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Rate Our Service',
            style: CTextTheme.blackTextTheme.displayMedium,
          ),
          Text(
            'Are you satisfied with our service?',
            style: CTextTheme.greyTextTheme.labelLarge,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            'Tell us what can be improved?',
            style: CTextTheme.blackTextTheme.headlineMedium,
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 8,
            children: _improvementOptions.map((option) {
              return ChoiceChip(
                label: Text(option, style: CTextTheme.greyTextTheme.labelLarge),
                selected: _selectedImprovements.contains(option),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedImprovements.add(option);
                    } else {
                      _selectedImprovements.remove(option);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Tell us how we can improve...',
              hintStyle: CTextTheme.greyTextTheme.headlineMedium,
              labelStyle: CTextTheme.blackTextTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 15.0),
          ElevatedButton(
            child: Text(
              'Submit',
              style: CTextTheme.blackTextTheme.headlineMedium,
            ),
            onPressed: () {
              _handleSubmitFeedback();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmitFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    // Decode the token and get the user ID
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
    String userId = jwtDecodedToken['_id'];
    int phoneNumber = jwtDecodedToken['phoneNumber'];

    // Create the newFeedback map
    Map<String, dynamic> newFeedback = {
      'user.userID': userId,
      'user.phoneNumber': phoneNumber,
      'starRating': _rating,
      'improvementCategories': _selectedImprovements,
      'message': _feedbackController.text,
    };

    try {
      // Continue with submitting feedback
      var reqUrl = '${url}createFeedback';
      final response = await http.post(
        Uri.parse(reqUrl),
        body: json.encode(newFeedback),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Feedback Submitted Successfully',
                style: CTextTheme.blackTextTheme.headlineLarge
              ),
              content: Text(
                'Thank you for your feedback!',
                style: CTextTheme.blackTextTheme.headlineMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                    // Navigate back to the previous screen
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: CTextTheme.blackTextTheme.headlineMedium,
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to submit feedback. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error submitting feedback: $error');
    }
  }
}
