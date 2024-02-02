import 'package:device_run_test/src/common_widgets/chat_widget.dart';
import 'package:device_run_test/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../../utilities/theme/widget_themes/elevatedbutton_theme.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final bool _isTyping = true;
  // late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top Bar of Chat Screen
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(cChatBotLogo),
            const SizedBox(width: 8.0,),
            Text('Trimi', style: Theme.of(context).textTheme.displaySmall,),
          ],
        ),
        actions: [
          //End Button
          ElevatedButton(
            onPressed: (){},
            style: CElevatedButtonTheme.lightElevatedButtonTheme.style,
            child: Text("End", style: Theme.of(context).textTheme.headlineMedium,),
            ),
        ],
      ),
      //Body containing chat bubble section & user input bar
      body: Container(
        padding: const EdgeInsets.all(cDefaultSize),
        child: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatMessages[index]["msg"].toString(),
                      chatIndex: int.parse(chatMessages[index]["chatIndex"].toString()),
                    );
                  }
                ),
              ),
              //Text Input Bar
              if(_isTyping) ...[
                Container(
                  width:  double.infinity,
                  height:  cButtonHeight + 10,
                  decoration:  BoxDecoration (
                    border: Border.all(
                      color: AppColors.cPrimaryColor,
                    ),
                    borderRadius:  BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: TextField(
                          // controller: textEditingController,
                          // onSubmitted: (value){
                          //   // TODO send message
                          // },
                          decoration: InputDecoration(
                            hintText: "message...",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){}, 
                        icon: Icon(Icons.send_rounded, color: AppColors.cPrimaryColor,),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}