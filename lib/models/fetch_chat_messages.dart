import 'package:ViacAkoNick/models/message.dart';

class FetchChatMessages {
  final List<Message> messages;
  final String ot;
  final bool closed;
  final bool checkStatus;
  final int lmid;

  FetchChatMessages({
    required this.messages,
    required this.ot,
    required this.closed,
    required this.checkStatus,
    required this.lmid,
  });

  factory FetchChatMessages.fromJson(Map<String, dynamic> json) {
    return FetchChatMessages(
      messages:
          List<Message>.from(json['messages'].map((x) => Message.fromJson(x))),
      ot: json['ot'],
      closed: json['closed'],
      checkStatus: json['check_status'],
      lmid: json['lmid'],
    );
  }
}
