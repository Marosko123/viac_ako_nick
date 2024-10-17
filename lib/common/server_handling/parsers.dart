import 'dart:convert';

import 'package:ViacAkoNick/common/global_variables.dart';
import 'package:ViacAkoNick/models/chat.dart';
import 'package:ViacAkoNick/models/fetch_chat_messages.dart';
import 'package:ViacAkoNick/models/operator.dart';

class Parsers {
  static List<Operator> parseOperators(String responseBody) {
    final parsed =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Operator>((json) => Operator.fromJson(json)).toList();
  }

  static Chat parseStartChat(String responseBody) {
    final parsed = jsonDecode(responseBody)['result'];

    var object = Chat.fromJson(parsed);

    return object;
  }

  static FetchChatMessages parseFetchChatMessages(String responseBody) {
    final parsed = jsonDecode(responseBody);

    var object = FetchChatMessages.fromJson(parsed['result']);

    return object;
  }
}
