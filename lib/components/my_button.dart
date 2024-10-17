import 'dart:io';

import 'package:ViacAkoNick/common/global_variables.dart';
import 'package:ViacAkoNick/common/server_handling/request_handler.dart';
import 'package:flutter/material.dart';

import '../common/my_colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.text, required this.onTap});

  void Function() onTapPressed(BuildContext context) {
    var chatId = GlobalVariables.chatId;
    return () {
      if (onTap != null) {
        onTap!();
      } else {
        closeApp(context, chatId);
      }
    };
  }

  Future<void> closeApp(BuildContext context, int chatId) async {
    await RequestHandler.closeChat(chatId);
    Navigator.of(context).pop();
    exit(0);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GestureDetector(
        onTap: onTapPressed(context),
        child: Container(
          padding: const EdgeInsets.all(25),
          // margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: MyColors.buttonColor,
            // borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: MyColors.buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
