class ApiRoutes {
  static final List<ApiRoutes> list = [];

  // create routes
  static final ApiRoutes isOnline = ApiRoutes('isonline', 'GET');
  static final ApiRoutes onlineUsers = ApiRoutes('onlineusers', 'GET');
  // getUsers - operators with their names and other params
  static final ApiRoutes getUsers = ApiRoutes('getusers', 'GET');
  static final ApiRoutes startChat = ApiRoutes('chat', 'POST');
  static final ApiRoutes updateChat = ApiRoutes('chat', 'PUT');
  static final ApiRoutes fetchChatMessages =
      ApiRoutes('fetchchatmessages', 'GET');
  static final ApiRoutes addMsgUser = ApiRoutes('addmsguser', 'POST');
  static final ApiRoutes deleteChat = ApiRoutes('chat', 'DELETE');
  static final ApiRoutes setChatStatus = ApiRoutes('setchatstatus', 'POST');

  final String path;
  final String method;

  ApiRoutes(this.path, this.method) {
    list.add(this);
  }

  String getFullRoute() {
    String baseUrl = 'https://viacakonick-chat.hexatech.sk/index.php/restapi/';

    return '$baseUrl$path';
  }
}
