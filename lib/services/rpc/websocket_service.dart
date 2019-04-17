import 'package:flutter_bitshares/models/api/api.dart';

abstract class WebsocketService {
  call(Callable getAccountByName);
}
