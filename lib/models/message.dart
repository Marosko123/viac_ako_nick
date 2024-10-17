class Message {
  final int id;
  final String msg;
  final String metaMsg;
  final int time;
  final int chatId;
  final int userId;
  final int delSt;
  final String nameSupport;

  Message({
    required this.id,
    required this.msg,
    required this.metaMsg,
    required this.time,
    required this.chatId,
    required this.userId,
    required this.delSt,
    required this.nameSupport,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      msg: json['msg'],
      metaMsg: json['meta_msg'],
      time: json['time'],
      chatId: json['chat_id'],
      userId: json['user_id'],
      delSt: json['del_st'],
      nameSupport: json['name_support'],
    );
  }
}
