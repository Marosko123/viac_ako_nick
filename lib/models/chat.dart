class Chat {
  final int id,
      // serverid,
      time,
      lastMsgId,
      status,
      userId,
      hasUnreadMessages,
      lastUserMsgTime,
      lastOpMsgTime;
  final String nick,
      email,
      ip,
      countryCode,
      countryName,
      referrer,
      uagent,
      departmentName,
      userTypingTxt,
      owner,
      phone;

  const Chat({
    required this.id,
    // required this.serverid,
    required this.status,
    required this.nick,
    required this.email,
    required this.ip,
    required this.time,
    required this.lastMsgId,
    required this.userId,
    required this.countryCode,
    required this.countryName,
    required this.referrer,
    required this.uagent,
    required this.departmentName,
    required this.userTypingTxt,
    required this.owner,
    required this.hasUnreadMessages,
    required this.lastUserMsgTime,
    required this.lastOpMsgTime,
    required this.phone,
  });

  static int checkInt(dynamic value) {
    if (value == null) return -1;
    return value is int ? value : int.parse(value);
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: checkInt(json['id']),
      // serverid: checkInt(json['serverid']),
      status: checkInt(json['status']),
      nick: json['nick'] ?? "",
      email: json['email'] ?? "",
      ip: json['ip'] ?? "",
      time: checkInt(json['time']),
      lastMsgId: checkInt(json['last_msg_id']),
      userId: checkInt(json['user_id']),
      countryCode: json['country_code'] ?? "",
      countryName: json['country_name'] ?? "",
      referrer: json['referrer'] ?? "",
      uagent: json['uagent'] ?? "",
      departmentName: json['department_name'] ?? "",
      userTypingTxt: json['user_typing_txt'] ?? "",
      owner: json['owner'] ?? "",
      hasUnreadMessages: checkInt(json['has_unread_messages']),
      lastUserMsgTime: checkInt(json['last_user_msg_time']),
      lastOpMsgTime: checkInt(json['last_op_msg_time']),
      phone: json['phone'] ?? "",
    );
  }
}
