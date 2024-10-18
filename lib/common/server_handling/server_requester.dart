// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ViacAkoNick/common/server_handling/api_connection.dart';
import 'package:ViacAkoNick/common/server_handling/routes.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';

class ServerRequester {
  static ApiConnection connection = ApiConnection();

  static Future<http.Response> request(
      {required ApiRoutes apiRoute,
      dynamic body,
      String? params,
      String contentType = 'application/json',
      String accept = 'application/json',
      String charset = 'utf-8',
      bool isXWWWFormUrlEncoded = false}) async {
    late http.Response response;

    try {
      String auth =
          'Basic ${base64.encode(utf8.encode('${connection.authorization.basic.username}:${connection.authorization.basic.password}'))}';

      if (isXWWWFormUrlEncoded) {
        contentType = 'application/x-www-form-urlencoded';

        // Encoding the body as x-www-form-urlencoded
        body = body.entries.map((entry) {
          return '${Uri.encodeComponent(entry.key.toString())}=${Uri.encodeComponent(entry.value.toString())}';
        }).join('&');
      } else {
        body = jsonEncode(body);
      }

      final headers = <String, String>{
        'Content-Type': contentType,
        'Authorization': auth,
        'Accept': auth,
        'Charset': charset,
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=100',
        'User-Agent': 'HexatechViacAkoNick',
      };

      var fullRoute = apiRoute.getFullRoute();

      if (params != null && params.isNotEmpty) {
        fullRoute += params;
      }

      switch (apiRoute.method) {
        case 'GET':
          response =
              await http.get(Uri.parse(fullRoute), headers: headers).timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw 'Server is not responding';
            },
          );
          break;
        case 'POST':
          response = await http
              .post(
            Uri.parse(fullRoute),
            headers: headers,
            body: body,
          )
              .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              throw 'Server is not responding';
            },
          );
          break;
        case 'PUT':
          response = await http.put(
            Uri.parse(fullRoute),
            headers: headers,
            body: body,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            Uri.parse(fullRoute),
            headers: headers,
            body: body,
          );
          break;
        case 'DELETE':
          response = await http.delete(Uri.parse(fullRoute), headers: headers);
          break;
        default:
          return http.Response('{"error": "Method not supported"}', 405);
      }

      GlobalVariables.isConnectedToServer = true;

      return response;
    } catch (e) {
      print(e);
      GlobalVariables.isConnectedToServer = false;
      return http.Response('{"error": "$e"}', 500);
    }
  }
}
