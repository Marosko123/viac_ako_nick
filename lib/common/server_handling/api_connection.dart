import 'package:ViacAkoNick/common/server_handling/routes.dart';

class ApiConnection {
  final Authorization authorization = Authorization();
  final List<ApiRoutes> routes = ApiRoutes.list;

  ApiConnection();
}

class Authorization {
  final BasicAuth basic = BasicAuth();
  final BearerAuth bearer = BearerAuth();
}

// Change this to your own credentials
class BasicAuth {
  final String username = 'RestAPI1';
  final String password = 'hexatech2024*';
}

class BearerAuth {
  final String token = 'Bearer <YOURTOKENHERE>';
}
