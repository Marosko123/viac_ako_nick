// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:ViacAkoNick/common/global_variables.dart';
import 'package:ViacAkoNick/common/server_handling/parsers.dart';
import 'package:ViacAkoNick/common/server_handling/routes.dart';
import 'package:ViacAkoNick/models/chat.dart';
import 'package:ViacAkoNick/models/fetch_chat_messages.dart';
import 'package:ViacAkoNick/models/operator.dart';
import 'package:flutter/foundation.dart';

import 'server_requester.dart';
import 'package:http/http.dart' as http;

class RequestHandler {
  static bool isOk(statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  // check connection to the server
  static Future<bool> isServerOnline() async {
    http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.isOnline,
    );

    return isOk(response.statusCode);
  }

  static Future<List<Operator>> getOnlineOperators() async {
    // fetch online operators
    final http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.onlineUsers,
      params: '?include_user=true',
    );

    if (!isOk(response.statusCode)) {
      return [];
    }

    return compute(Parsers.parseOperators, response.body);
  }

  static Future<Chat?> startChatRoom(Map<String, dynamic> body) async {
    final http.Response response = await ServerRequester.request(
        apiRoute: ApiRoutes.startChat, body: body);

    if (!isOk(response.statusCode)) {
      return null;
    }

    var result = await compute(Parsers.parseStartChat, response.body);

    GlobalVariables.chatId = result.id;

    return result;
  }

  static Future<FetchChatMessages> fetchChatMessages() async {
    final http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.fetchChatMessages,
      params: '?chat_id=${GlobalVariables.chatId}',
    );

    if (!isOk(response.statusCode)) {
      return FetchChatMessages(
        messages: [],
        ot: '',
        closed: false,
        checkStatus: false,
        lmid: 0,
      );
    }

    return compute(Parsers.parseFetchChatMessages, response.body);
  }

  static Future<bool> addMsgUser(int chatId, String msg) async {
    final http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.addMsgUser,
      body: {
        'chat_id': chatId,
        'msg': msg,
      },
      isXWWWFormUrlEncoded: true,
    );

    print('Content type: ${response.headers['content-type']}');
    print('Content type: ${response.request?.headers['content-type']}');

    if (!isOk(response.statusCode)) {
      print('Error adding message: ${response.body}');
      return false;
    }

    return true;
  }

  static Future<void> deleteChat(int chatId) async {
    if (chatId == -1) {
      print('Chat was not created, chatId is -1');
      return;
    }

    final http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.deleteChat,
      params: '?chat_id=$chatId',
    );

    if (!isOk(response.statusCode)) {
      print('Error deleting chat: ${response.body}');
      return;
    }

    print('Chat deleted');
  }

  static Future<void> setChatOperatorId(int chatId, int operatorId) async {
    print('Setting chat[$chatId] operator ID to "$operatorId"');

    final http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.updateChat,
      body: {
        'chat_id': chatId,
        'operator_id': operatorId,
      },
    );

    if (!isOk(response.statusCode)) {
      print('Error setting chat status: ${response.body}');
      return;
    }
  }

  static Future<void> setChatStatus(int chatId, int status) async {
    print('Setting chat[$chatId] status to $status');

    final http.Response response = await ServerRequester.request(
      apiRoute: ApiRoutes.setChatStatus,
      body: {
        'chat_id': chatId,
        'status': status,
      },
      isXWWWFormUrlEncoded: true,
    );

    if (!isOk(response.statusCode)) {
      print('Error setting chat status: ${response.body}');
      return;
    }

    print('Chat status set');
  }

  static Future<void> closeChat(int chatId) async {
    await setChatStatus(chatId, 2);
  }

  // TODO: prilohy
}
