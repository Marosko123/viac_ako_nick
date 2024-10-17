import 'package:ViacAkoNick/models/user.dart';

class Operator {
  final int id;
  final int userId;
  final int depId;
  final int hideOnlineTs;
  final int hideOnline;
  final int lastActivity;
  final int lastdActivity;
  final int lastAccepted;
  final int lastAcceptedMail;
  final int activeChats;
  final int pendingChats;
  final int inactiveChats;
  final int activeMails;
  final int pendingMails;
  final int alwaysOn;
  final int ro;
  final int type;
  final int depGroupId;
  final int excludeAutoasign;
  final int excludeAutoasignMails;
  final int excIndvAutoasign;
  final int maxChats;
  final int maxMails;
  final int assignPriority;
  final int chatMinPriority;
  final int chatMaxPriority;
  final List<dynamic> depIdFilter;
  final bool isOnline;
  final int invisibleMode;
  final User user;

  const Operator({
    required this.id,
    required this.userId,
    required this.depId,
    required this.hideOnlineTs,
    required this.hideOnline,
    required this.lastActivity,
    required this.lastdActivity,
    required this.lastAccepted,
    required this.lastAcceptedMail,
    required this.activeChats,
    required this.pendingChats,
    required this.inactiveChats,
    required this.activeMails,
    required this.pendingMails,
    required this.alwaysOn,
    required this.ro,
    required this.type,
    required this.depGroupId,
    required this.excludeAutoasign,
    required this.excludeAutoasignMails,
    required this.excIndvAutoasign,
    required this.maxChats,
    required this.maxMails,
    required this.assignPriority,
    required this.chatMinPriority,
    required this.chatMaxPriority,
    required this.depIdFilter,
    required this.isOnline,
    required this.invisibleMode,
    required this.user,
  });

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      depId: json['dep_id'] as int,
      hideOnlineTs: json['hide_online_ts'] as int,
      hideOnline: json['hide_online'] as int,
      lastActivity: json['last_activity'] as int,
      lastdActivity: json['lastd_activity'] as int,
      lastAccepted: json['last_accepted'] as int,
      lastAcceptedMail: json['last_accepted_mail'] as int,
      activeChats: json['active_chats'] as int,
      pendingChats: json['pending_chats'] as int,
      inactiveChats: json['inactive_chats'] as int,
      activeMails: json['active_mails'] as int,
      pendingMails: json['pending_mails'] as int,
      alwaysOn: json['always_on'] as int,
      ro: json['ro'] as int,
      type: json['type'] as int,
      depGroupId: json['dep_group_id'] as int,
      excludeAutoasign: json['exclude_autoasign'] as int,
      excludeAutoasignMails: json['exclude_autoasign_mails'] as int,
      excIndvAutoasign: json['exc_indv_autoasign'] as int,
      maxChats: json['max_chats'] as int,
      maxMails: json['max_mails'] as int,
      assignPriority: json['assign_priority'] as int,
      chatMinPriority: json['chat_min_priority'] as int,
      chatMaxPriority: json['chat_max_priority'] as int,
      depIdFilter: json['dep_id_filter'] as List<dynamic>,
      isOnline: json['is_online'] as bool,
      invisibleMode: json['invisible_mode'] as int,
      user: User.fromJson(json['user']),
    );
  }
}
