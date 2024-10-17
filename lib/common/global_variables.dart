import 'dart:io';
import 'package:ViacAkoNick/models/operator.dart';
import 'package:ViacAkoNick/models/user.dart';

class GlobalVariables {
  static String serverIP = Platform.isWindows
      ? '127.0.0.1'
      : '147.175.161.191'; // replace IP value with your server IP
  static bool? isConnectedToServer;
  static bool hasInternetConnection = false;
  static bool isUserLoggedIn = false;
  static String token = '';
  static int operatorId = 0;
  static String operatorName = '';
  static User user = User();
  static String phone = '';
  static String question = '';
  static List<Operator> onlineOperators = [];
  static int chatId = -1;
  static bool isFetchingMessages = false;
}
