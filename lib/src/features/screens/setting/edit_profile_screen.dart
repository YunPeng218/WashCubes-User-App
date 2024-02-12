import 'dart:convert';
import 'dart:io';
import 'package:device_run_test/config.dart';
import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:device_run_test/src/features/models/user.dart';
import 'package:device_run_test/src/utilities/user_helper.dart';
import 'package:device_run_test/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
          children: <Widget>[
            if (user!=null)
            ProfileHeader(user: user),
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
  UserProfile? user;
  ProfileHeader({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State <ProfileHeader> {
  File? imageFile;
  String? imageUrl;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.user!.profilePicURL;
  }

  Future<void> pickImage (ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: source);
    setState((){
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        uploadImage();
      }
    });
  }

  Future<void> uploadImage() async {
    setState(() {
      isUploading = true;
    });
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/ddweldfmx/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'xcbbr3ok'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));
      final response = await request.send();
      print('Upload response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = utf8.decode(responseData);
        final jsonMap = jsonDecode(responseString);
        setState(() {
          final url = jsonMap['url'];
          imageUrl = url;
        });
        updateProfilePicURL(imageUrl);
      }
    } catch (error) {
      print('Error uploading image: $error');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }


  Future<void> updateProfilePicURL(imageUrl) async {
    Map<String, dynamic> newDetails = {
      'userId': widget.user!.id,
      'profilePicURL': imageUrl,
    };

    final response = await http.patch(
      Uri.parse('${url}userProfilePic'),
      body: json.encode(newDetails),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('user')) {
        final dynamic userData = data['user'];
        setState(() {
          widget.user = UserProfile.fromJson(userData);
        });
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile picture updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  imageUrl!,
                ),
              ),
            ),
            if (isUploading)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            IconButton(
              icon: const Icon(
                Icons.camera_enhance,
                color: Colors.grey,
              ),
              onPressed: () {
                if (!isUploading) {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.camera),
                            title: const Text('Take a photo'),
                            onTap: () {
                              Navigator.pop(context);
                              pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image),
                            title: Text('Choose from gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
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
  _EditProfilePageState? pageState;

  @override
  void initState() {
    super.initState();
    pageState = context.findAncestorStateOfType<_EditProfilePageState>();
  }

  Future<void> updateUserDetails(String title, String value) async {
    try {
      Map<String, dynamic> newDetails = {
        'userId': widget.user!.id,
      };

      switch (title) {
        case 'PREFERRED NAME':
          newDetails['name'] = value;
          newDetails['email'] = widget.user!.email;
          newDetails['phoneNumber'] = widget.user!.phoneNumber;
          break;
        case 'MOBILE NUMBER':
          newDetails['phoneNumber'] = value;
          newDetails['name'] = widget.user!.name;
          newDetails['email'] = widget.user!.email;
          break;
        case 'EMAIL ADDRESS':
          newDetails['email'] = value;
          newDetails['name'] = widget.user!.name;
          newDetails['phoneNumber'] = widget.user!.phoneNumber;
          break;
      }

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

  void showEditDialog(BuildContext context, String title, String currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog(
          title: title,
          currentValue: currentValue,
          onEdit: (newValue) {
            updateUserDetails(title, newValue);
            pageState?.loadUserInfo();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
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
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.cGreyColor2),
                onPressed: () {
                  showEditDialog(context, widget.title, widget.value);
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

class EditProfileDialog extends StatefulWidget {
  final String title;
  final String currentValue;
  final Function(String) onEdit;

  const EditProfileDialog({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.onEdit,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentValue;
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPhoneNumber = widget.title == 'MOBILE NUMBER';
    return AlertDialog(
      title: Text('Edit ${widget.title}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          focusNode: _focusNode,
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.title,
          ),
          keyboardType: isPhoneNumber ? TextInputType.phone : TextInputType.text,
          inputFormatters: isPhoneNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : null, // Allow only numeric input if it's a phone number
          validator: (value) {
            if (widget.title == 'EMAIL ADDRESS' && !RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value ?? '')) {
              return 'Enter a valid email address';
            } else if (widget.title == 'MOBILE NUMBER' && !RegExp(r'^601[0-46-9][0-9]{7,8}$').hasMatch(value ?? '')) {
              return 'Enter a valid phone number starting with 601';
            } else if (value == '') {
              return 'Enter a value';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              widget.onEdit(_controller.text);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}