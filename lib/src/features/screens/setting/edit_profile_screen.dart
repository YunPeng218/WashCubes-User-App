import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:device_run_test/src/constants/sizes.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: Theme.of(context).textTheme.displaySmall,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(cDefaultSize),
        child: ListView(
          // padding: const EdgeInsets.all(16),
          children: const <Widget>[
            ProfileHeader(),
            EditableProfileItem(title: 'PREFERRED NAME', value: 'Trimity Wang'),
            EditableProfileItem(title: 'MOBILE NUMBER', value: '+60 14-096 0912'),
            EditableProfileItem(title: 'EMAIL ADDRESS', value: 'trimityi3@gmail.com'),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage(cAvatar),
          radius: 50,
        ),
        const SizedBox(height: 10),
        IntrinsicWidth(
          child: TextButton(
            style: ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStateProperty.all<Color>(AppColors.cGreyColor1),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('#90601912023', style: TextStyle(color: AppColors.cGreyColor3, fontSize: 15),),
                Icon(Icons.copy, color: AppColors.cGreyColor3,),
              ],
            ),
          ),
        ),
        // Text(
        //   '20,322 i3Coins',
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class EditableProfileItem extends StatelessWidget {
  final String title;
  final String value;

  const EditableProfileItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
                value,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.cGreyColor2),
                onPressed: () {
                  // Implement edit functionality
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
