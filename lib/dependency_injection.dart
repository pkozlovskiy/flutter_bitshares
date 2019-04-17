
import 'package:flutter_bitshares/services/rpc/bitshares_websocket_service.dart';
import 'package:flutter_bitshares/services/rpc/mock_websocket_service.dart';
import 'package:flutter_bitshares/services/rpc/websocket_service.dart';

enum Flavor { MOCK, PRO }

//Simple DI
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) async {
    _flavor = flavor;
  }

  factory Injector() => _singleton;

  Injector._internal();

  WebsocketService get websocketService {
    switch (_flavor) {
      case Flavor.MOCK:
        return MockWebsocketService();
      default:
        return BitsharesWebsocketService();
    }
  }
}
