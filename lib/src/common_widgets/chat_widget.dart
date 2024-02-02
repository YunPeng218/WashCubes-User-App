import 'package:device_run_test/src/constants/colors.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

import '../constants/sizes.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? AppColors.cGreyColor3:AppColors.cBlueColor2,
          child: Padding(
            padding: const EdgeInsets.all(cDefaultSize),
            child: Row(
              children: [
                Image.asset(
                  chatIndex == 0 ? cChatBotLogo:cAvatar),
                // TextWidget(
                //   label:msg,
                // )
              ],
            ),
          ),
        )
      ],
    );
  }
}
