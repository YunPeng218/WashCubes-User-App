import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary/cloudinary.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State <EditProfilePage> {
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'No token';
    if (token != 'No token') loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      var userHelper = UserHelper();
      UserProfile? foundUser = await userHelper.getUserDetails();
      if (mounted) {
        setState(() {
          user = foundUser;
        });
      }
    } catch (error) {
      print('Failed to load user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: CTextTheme.blackTextTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ListView(
          // padding: const EdgeInsets.all(16),
          children: <Widget>[
            ProfileHeader(),
            if (user!=null)
              EditableProfileItem(title: 'PREFERRED NAME', value: user!.name, user: user),
            if (user!=null)
              EditableProfileItem(title: 'MOBILE NUMBER', value: user!.phoneNumber.toString(), user: user),
            if (user!=null)
              EditableProfileItem(title: 'EMAIL ADDRESS', value: user!.email, user: user),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State <ProfileHeader> {
  File? imageFile;
  String? imageUrl;

  Future<void> pickImage (ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: source);
    setState((){
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  final cloudinary = Cloudinary.unsignedConfig(
    cloudName: 'ddweldfmx',
  );

  Future<void> uploadImage() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/ddweldfmx/upload');
  }

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      GestureDetector(
        onTap: () {
          // selectImage();
        },
        child: CircleAvatar(
          backgroundImage: AssetImage(cAvatar),
          radius: 50,
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}
}

class EditableProfileItem extends StatefulWidget {
  String title;
  String value;
  UserProfile? user;

  EditableProfileItem({Key? key, required this.title, required this.value, required this.user}) : super(key: key);

  @override
  _EditableProfileItemState createState() => _EditableProfileItemState();
}

class _EditableProfileItemState extends State<EditableProfileItem> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _editingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.value);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isEditing = false;
        });
      }
    });
  }

  Future<void> updateUserDetails(String title, String value) async {
    try {
      Map<String, dynamic> newDetails = {
        'userId': widget.user!.id,
        'name': title == 'PREFERRED NAME' ? value : widget.user!.name,
        'phoneNumber': title == 'MOBILE NUMBER' ? value : widget.user!.phoneNumber,
        'email': title == 'EMAIL ADDRESS' ? value : widget.user!.email,
      };

      final response = await http.patch(
        Uri.parse('${url}user'),
        body: json.encode(newDetails),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _EditProfilePageState? pageState = context.findAncestorStateOfType<_EditProfilePageState>();
        if (pageState != null) {
          pageState.loadUserInfo();
        }
      } else {
        throw Exception('Failed to update user details');
      }
    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: CTextTheme.greyTextTheme.labelLarge
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _isEditing 
                  ? Expanded(
                      child: TextFormField(
                        controller: _editingController,
                        focusNode: _focusNode,
                        style: Theme.of(context).textTheme.headlineLarge,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (newValue) {
                          widget.value = newValue;
                          updateUserDetails(widget.title, widget.value);
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                      ),
                    )
                  : Expanded(
                      child: Text(
                        widget.value,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.cGreyColor2),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                  _focusNode.requestFocus();
                },
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}