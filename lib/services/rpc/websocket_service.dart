
import 'package:graphened/graphened.dart';

abstract class WebsocketService {
  Future<Response> call(Callable callable);
}
