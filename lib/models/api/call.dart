class Call {
  static Map<int, int> apiIds = {};

  int id;
  int apiId = ApiType.API_NONE;
  String method = 'call';
  String methodToCall;
  List<dynamic> params;

  Call(this.id, this.methodToCall, this.params, this.apiId);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['method'] = method;
    data['params'] = [apiId, methodToCall, params];
    return data;
  }
}

abstract class Callable {
  Call toCall(int id);
}

class RequestApiTypeCall extends Callable {
  final String requestedApiMethod;

  RequestApiTypeCall(this.requestedApiMethod);

  @override
  Call toCall(int id) {
    return Call(id, requestedApiMethod, [], 1);
  }
}

class LoginCall extends Callable {
  final String username, pass;

  LoginCall(this.username, this.pass);

  @override
  Call toCall(int id) {
    return Call(id, RPC.CALL_LOGIN, List<dynamic>.from([username, pass]), 1);
  }
}

class ApiType {
  static const int API_NONE = 0x00;
  static const int API_DATABASE = 0x01;
  static const int API_HISTORY = 0x02;
  static const int API_NETWORK_BROADCAST = 0x04;
}

class RPC {
  static const String VERSION = "2.0";
  static const String CALL_LOGIN = "login";
  static const String CALL_NETWORK_BROADCAST = "network_broadcast";
  static const String CALL_HISTORY = "history";
  static const String CALL_DATABASE = "database";
  static const String CALL_ASSET = "asset";
  static const String CALL_SET_SUBSCRIBE_CALLBACK = "set_subscribe_callback";
  static const String CALL_CANCEL_ALL_SUBSCRIPTIONS =
      "cancel_all_subscriptions";
  static const String CALL_GET_ACCOUNT_BY_NAME = "get_account_by_name";
  static const String CALL_GET_ACCOUNTS = "get_accounts";
  static const String CALL_GET_FULL_ACCOUNTS = "get_full_accounts";
  static const String CALL_GET_DYNAMIC_GLOBAL_PROPERTIES =
      "get_dynamic_global_properties";
  static const String CALL_BROADCAST_TRANSACTION = "broadcast_transaction";
  static const String CALL_GET_REQUIRED_FEES = "get_required_fees";
  static const String CALL_GET_KEY_REFERENCES = "get_key_references";
  static const String CALL_GET_RELATIVE_ACCOUNT_HISTORY =
      "get_relative_account_history";
  static const String CALL_GET_ACCOUNT_HISTORY = "get_account_history";
  static const String CALL_GET_ACCOUNT_HISTORY_BY_OPERATIONS =
      "get_account_history_by_operations";
  static const String CALL_LOOKUP_ACCOUNTS = "lookup_accounts";
  static const String CALL_LIST_ASSETS = "list_assets";
  static const String CALL_GET_ASSETS = "get_assets";
  static const String CALL_GET_OBJECTS = "get_objects";
  static const String CALL_GET_ACCOUNT_BALANCES = "get_account_balances";
  static const String CALL_LOOKUP_ASSET_SYMBOLS = "lookup_asset_symbols";
  static const String CALL_GET_BLOCK_HEADER = "get_block_header";
  static const String CALL_GET_BLOCK = "get_block";
  static const String CALL_GET_LIMIT_ORDERS = "get_limit_orders";
  static const String CALL_GET_TRADE_HISTORY = "get_trade_history";
  static const String CALL_GET_MARKET_HISTORY = "get_market_history";
  static const String CALL_GET_ALL_ASSET_HOLDERS = "get_all_asset_holders";
  static const String CALL_GET_TRANSACTION = "get_transaction";
}
