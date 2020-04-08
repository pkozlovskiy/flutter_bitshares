import 'package:graphened/graphened.dart';
import 'package:rxdart/rxdart.dart';

abstract class WebsocketService {
  Future<Response> call(Callable callable);

  Subject<Response> get messages;
}
