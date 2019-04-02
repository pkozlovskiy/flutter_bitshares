import 'dart:convert';

import 'package:flutter_bitshares/models/api/call.dart';
import 'package:flutter_bitshares/models/api/responce.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/io.dart';

class NetworkService {
  final Logger log = Logger("NetworkService");
  static const int NORMAL_CLOSURE_STATUS = 1000;
  static const int GOING_AWAY_STATUS = 1001;
  bool _loggedIn = false;
  int _currentId = 0;
  String _lastCall;
  int _requestedApis = ApiType.API_DATABASE |
      ApiType.API_HISTORY |
      ApiType.API_NETWORK_BROADCAST;

  static final _instance = NetworkService._internal();

  NetworkService._internal() {
    connect();
  }

  factory NetworkService() {
    return _instance;
  }

  IOWebSocketChannel _channel;

  void connect() async {
    log.info("WebSocket connecting...");
    try {
      _channel = IOWebSocketChannel.connect("wss://node.testnet.bitshares.eu");
      _channel.stream.listen((str) {
        Map json = jsonDecode(str);
        onData(json);
      }, onError: (error, StackTrace stackTrace) {
        log.severe("WebSocket onError:$error, stackTrace:$stackTrace");
        _onDisconnect(true);
      }, onDone: () async {
        var code = _channel.closeCode;
        var msg = _channel.closeReason;
        log.warning("WebSocket onDone: msg=$msg, code=$code");
        _onDisconnect(code != NORMAL_CLOSURE_STATUS);
      }, cancelOnError: true);
    } catch (e) {
      log.severe("WebSocket open error:$e");
    }
    log.info("WebSocket conected");
    if (!_loggedIn) {
      LoginCall loginMsg = LoginCall("", "");
      _lastCall = RPC.CALL_LOGIN;
      call(loginMsg);
    }
  }

  void onData(str) {
    log.info("OnData: $str");
    Response response = Response.fromJson(str);
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

  void handleRpcResponce(Response response, str) {}

  bool isConnected() {
    return _channel != null && _loggedIn;
  }

  void _onDisconnect(bool tryReconnect) {
    log.info("onDisconnect with tryReconnect = $tryReconnect");
    _loggedIn = false;
    _currentId = 0;
    Call.apiIds.clear();
    if (tryReconnect) {
      Future.delayed(const Duration(seconds: 1), () => connect());
    }
  }

  void call(Callable callable) {
    if (_channel != null) {
      var call = callable.toCall(++_currentId);
      log.info("sendMessage: ${call.toJson()}");
      var json = jsonEncode(call);
      _channel.sink.add(json);
    } else {
      throw Exception('Websocket connection has not yet been established');
    }
  }

  void dispose() {
    log.info("dispose....");
    if (_channel != null) _channel.sink.close(NORMAL_CLOSURE_STATUS);
  }
}
