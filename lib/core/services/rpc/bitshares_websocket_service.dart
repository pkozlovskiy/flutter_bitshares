import 'dart:async';
import 'dart:convert';

import 'package:flutter_wallet/core/services/rpc/websocket_service.dart';
import 'package:graphened/graphened.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class BitsharesWebsocketService implements WebsocketService {
  var log = Logger();

  static const int NORMAL_CLOSURE_STATUS = 1000;
  static const int GOING_AWAY_STATUS = 1001;
  bool _loggedIn = false;
  int _currentId = 0;
  final _completers = <int, Completer<Response>>{};
  final _callClassMap = <int, Type>{};

  String _lastCall;

  int _requestedApis = ApiType.API_DATABASE |
      ApiType.API_HISTORY |
      ApiType.API_NETWORK_BROADCAST;

  String _pass = "";

  String _username = "";

  static const String NODE_URL = "wss://eu.nodes.bitshares.ws";

  static final _instance = BitsharesWebsocketService._internal();
  var controller = new PublishSubject<Response>();

  @override
  Subject<Response> get messages => controller;

  IOWebSocketChannel _channel;

  factory BitsharesWebsocketService() {
    return _instance;
  }

  BitsharesWebsocketService._internal() {
    connect();
  }

  void connect() async {
    log.i("Connecting to $NODE_URL...");
    try {
      _channel = IOWebSocketChannel.connect(NODE_URL);
      _channel.stream.listen((str) {
        Map json = jsonDecode(str);
        onData(json);
      }, onError: (error, StackTrace stackTrace) {
        log.w("onError:$error, stackTrace:$stackTrace");
        _onDisconnect(true);
      }, onDone: () async {
        var code = _channel.closeCode;
        var msg = _channel.closeReason;
        log.w("onDone: msg=$msg, code=$code");
        _onDisconnect(code != NORMAL_CLOSURE_STATUS);
      }, cancelOnError: true);
    } catch (e) {
      log.w("Open error:$e");
    }
    log.i("Conected to $NODE_URL");
    if (!_loggedIn) {
      login();
    }
  }

  Future<Response> call(Callable callable) async {
    if (_channel != null && _channel.sink != null) {
      var call = callable.toCall(++_currentId);
      log.i("-> ${call.toJson()}");
      final completer = Completer<Response>.sync();
      _completers[_currentId] = completer;
      _callClassMap[_currentId] = callable.runtimeType;
      var json = jsonEncode(call);
      _channel.sink.add(json);
      return completer.future;
    } else {
      throw Exception('Connection has not yet been established');
    }
  }

  void onData(str) {
    log.i("<- $str");
    Response response = Response.fromJson(str);
    _completers.remove(response.id)?.complete(response);
    if (response.result != null) {
      if (response.result is int || response.result is bool) {
        switch (_lastCall) {
          case RPC.CALL_LOGIN:
            {
              _loggedIn = true;
              requestApiAccess();
            }
            break;
          case RPC.CALL_DATABASE:
            {
              Call.apiIds
                  .putIfAbsent(ApiType.API_DATABASE, () => response.result);
              requestApiAccess();
            }
            break;
          case RPC.CALL_HISTORY:
            {
              Call.apiIds
                  .putIfAbsent(ApiType.API_HISTORY, () => response.result);
              requestApiAccess();
            }
            break;
          case RPC.CALL_NETWORK_BROADCAST:
            {
              Call.apiIds.putIfAbsent(
                  ApiType.API_NETWORK_BROADCAST, () => response.result);
            }
            break;
        }
      }
    }
    handleRpcResponce(response, str);
  }

  void login() {
    LoginCall loginMsg = LoginCall(_username, _pass);
    _lastCall = RPC.CALL_LOGIN;
    call(loginMsg);
  }

  void requestApiAccess() {
    if ((_requestedApis & ApiType.API_DATABASE) == ApiType.API_DATABASE &&
        !Call.apiIds.containsKey(ApiType.API_DATABASE)) {
      _lastCall = RPC.CALL_DATABASE;
      call(RequestApiTypeCall(RPC.CALL_DATABASE));
    } else if ((_requestedApis & ApiType.API_HISTORY) == ApiType.API_HISTORY &&
        !Call.apiIds.containsKey(ApiType.API_HISTORY)) {
      _lastCall = RPC.CALL_HISTORY;
      call(RequestApiTypeCall(RPC.CALL_HISTORY));
    } else if ((_requestedApis & ApiType.API_NETWORK_BROADCAST) ==
            ApiType.API_NETWORK_BROADCAST &&
        !Call.apiIds.containsKey(ApiType.API_NETWORK_BROADCAST)) {
      _lastCall = RPC.CALL_NETWORK_BROADCAST;
      call(RequestApiTypeCall(RPC.CALL_NETWORK_BROADCAST));
    }
  }

  void handleRpcResponce(Response response, str) {
    Type callClass = _callClassMap.remove(response.id);
    if (callClass != null) {
      response.type = callClass;
    }
    controller.add(response);
  }

  bool isConnected() {
    return _channel != null && _loggedIn;
  }

  void _onDisconnect(bool tryReconnect) {
    log.i("onDisconnect with tryReconnect = $tryReconnect");
    _loggedIn = false;
    _currentId = 0;
    Call.apiIds.clear();
    if (tryReconnect) {
      Future.delayed(const Duration(seconds: 1), () => connect());
    }
  }

  void dispose() {
    log.i("dispose...");
    if (_channel != null) _channel.sink.close(NORMAL_CLOSURE_STATUS);
    controller.close();
  }
}
