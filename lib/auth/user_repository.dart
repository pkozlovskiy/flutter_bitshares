import 'package:flutter_bitshares/services/rpc/websocket_service.dart';
import 'package:graphened/graphened.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final WebsocketService service;
  static const String KEY_ACCOUNT_ID = 'KEY_ACCOUNT_ID';
  final SharedPreferences _storage;

  UserRepository(this.service, this._storage);

  Future<String> isAuth() async {
    var id = _storage.getString(KEY_ACCOUNT_ID);
    return id;
  }

  Future<UserAccount> signIn(
      {@required String username, @required String pass}) async {
    Response response = await service.call(GetAccountByName(username));
    return UserAccount.fromJson(response.result);
  }

  //TODO: todo
  Future<UserAccount> signUp(
          {@required String username, @required String pass}) async =>
      null;

  Future<void> auth(UserAccount userAccount) async {
    assert(userAccount != null && userAccount.id != null);
    await _storage.setString(KEY_ACCOUNT_ID, userAccount.id);
    return;
  }

  Future<void> signOut() async {
    await _storage.setString(KEY_ACCOUNT_ID, null);
    return;
  }

  Future<UserAccount> getUserAccount(String username) async {
    Response response = await service.call(GetAccountByName(username));
    return response.result != null
        ? UserAccount.fromJson(response.result)
        : null;
  }
}
