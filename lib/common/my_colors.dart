import 'package:flutter/material.dart';

class MyColors {
  static bool isDarkMode = false;

  static late Color textColor;
  static late Color dropdownColor;
  static late Color dropdownContentColor;
  static late Color backgroundColor;
  static late Color dividerColor;
  static late Color buttonTextColor;
  static late Color buttonColor;
  static late Color startChatButtonColor;
  static late Color textFieldFillColor;
  static late Color textFieldHintColor;
  static late Color chatBubbleRightColor;
  static late Color chatBubbleLeftColor;
  static late Color logoColor;
  static late Color switchButtonDisabled;
  static late Color switchButtonHighlighted;
  static late Color switchButtonBorder;
  static late Color shoppingCartItemBubble;
  static late Color popupBackgroundColor;
  static late Color popupTextColor;

  static const Map<String, Color> lightColors = {
    "background": Color.fromARGB(255, 228, 227, 227),
    "dropdown": Color.fromARGB(255, 173, 173, 173),
    "dropdownContent": Color.fromARGB(255, 204, 204, 204),
    "divider": Color.fromARGB(255, 158, 158, 158),
    "buttonText": Color.fromARGB(255, 255, 255, 255),
    "button": Color.fromARGB(255, 180, 73, 73),
    "startChatButtonColor": Color.fromARGB(255, 12, 192, 224),
    "textFieldFill": Color.fromARGB(255, 238, 238, 238),
    "textFieldHint": Color.fromARGB(255, 158, 158, 158),
    "text": Color.fromARGB(255, 236, 236, 236),
    "chatBubbleRight": Color.fromARGB(255, 0, 76, 138),
    "chatBubbleLeft": Color.fromARGB(255, 8, 156, 214),
    "logo": Color.fromARGB(255, 4, 133, 0),
    "switchButtonDisabled": Color.fromARGB(255, 211, 211, 211),
    "switchButtonHighlighted": Color.fromARGB(255, 255, 255, 255),
    "switchButtonBorder": Color.fromARGB(255, 0, 0, 0),
    "shoppingCartItemBubble": Color.fromARGB(255, 145, 230, 48),
    "popupBackground": Color.fromARGB(255, 40, 102, 44),
    "popupText": Color.fromARGB(255, 255, 255, 255),
  };

  static const Map<String, Color> darkColors = {
    "background": Color.fromARGB(255, 0, 0, 0),
    "dropdown": Color.fromARGB(255, 85, 85, 85),
    "dropdownContent": Color.fromARGB(255, 100, 100, 100),
    "text": Color.fromARGB(255, 255, 255, 255),
    "divider": Color.fromARGB(255, 255, 255, 255),
    "buttonText": Color.fromARGB(255, 0, 0, 0),
    "button": Color.fromARGB(255, 255, 255, 255),
    "startChatButtonColor": Color.fromARGB(255, 0, 153, 180),
    "textFieldFill": Color.fromARGB(255, 112, 112, 112),
    "textFieldHint": Color.fromARGB(255, 241, 241, 241),
    "chatBubbleRight": Color.fromARGB(255, 0, 153, 180),
    "chatBubbleLeft": Color.fromARGB(255, 0, 197, 59),
    "logo": Color.fromARGB(255, 24, 104, 87),
    "switchButtonDisabled": Color.fromARGB(255, 0, 0, 0),
    "switchButtonHighlighted": Color.fromARGB(255, 90, 90, 90),
    "switchButtonBorder": Color.fromARGB(255, 255, 255, 255),
    "shoppingCartItemBubble": Color.fromARGB(255, 77, 117, 32),
    "popupBackground": Color.fromARGB(255, 255, 255, 255),
    "popupText": Color.fromARGB(255, 0, 0, 0),
  };

  static void setColors() {
    Map<String, Color> colors = isDarkMode ? darkColors : lightColors;

    MyColors.textColor = colors["text"]!;
    MyColors.dropdownColor = colors["dropdown"]!;
    MyColors.dropdownContentColor = colors["dropdownContent"]!;
    MyColors.backgroundColor = colors["background"]!;
    MyColors.dividerColor = colors["divider"]!;
    MyColors.buttonTextColor = colors["buttonText"]!;
    MyColors.buttonColor = colors["button"]!;
    MyColors.startChatButtonColor = colors["startChatButtonColor"]!;
    MyColors.textFieldFillColor = colors["textFieldFill"]!;
    MyColors.textFieldHintColor = colors["textFieldHint"]!;
    MyColors.chatBubbleRightColor = colors["chatBubbleRight"]!;
    MyColors.chatBubbleLeftColor = colors["chatBubbleLeft"]!;
    MyColors.logoColor = colors["logo"]!;
    MyColors.switchButtonDisabled = colors["switchButtonDisabled"]!;
    MyColors.switchButtonHighlighted = colors["switchButtonHighlighted"]!;
    MyColors.switchButtonBorder = colors["switchButtonBorder"]!;
    MyColors.shoppingCartItemBubble = colors["shoppingCartItemBubble"]!;
    MyColors.popupBackgroundColor = colors["popupBackground"]!;
    MyColors.popupTextColor = colors["popupText"]!;
  }

  static void changeColors(bool value) {
    isDarkMode = value;
    setColors();
  }
}
