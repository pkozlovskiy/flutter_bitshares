import 'dart:async';

import 'package:flutter_bitshares/services/rpc/websocket_service.dart';
import 'package:graphened/graphened.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRepository {
  Stream<UserAccount> get onUserAccountChanged;
  UserAccount get currentUser;
  Future<UserAccount> signIn(String name, String password);
  // Future<UserAccount> createUser(String name, String password);
  Future<void> signOut();

  dispose();
}

class UserRepositoryImp extends UserRepository {
  final WebsocketService _service;
  static const String KEY_ACCOUNT_ID = 'KEY_ACCOUNT_ID';
  final SharedPreferences _storage;

  UserAccount currentUser;

  StreamController _onAuthStateChangedController =
      StreamController<UserAccount>.broadcast();

  UserRepositoryImp(this._service, this._storage) {
    var id = _storage.getString(KEY_ACCOUNT_ID) ?? '';
    _add(UserAccount(id));
  }

  @override
  Future<UserAccount> signIn(String username, String pass) async {
    Response response = await _service.call(GetAccountByName(username));
    var userAccount = UserAccount.fromJson(response.result);
    _add(userAccount);
    return userAccount;
  }

  Future<void> signOut() async {
    _add(null);
    return;
  }

  Future<UserAccount> getUserAccount(String username) async {
    Response response = await _service.call(GetAccountByName(username));
    return response.result != null
        ? UserAccount.fromJson(response.result)
        : null;
  }

  _add(UserAccount user) {
    currentUser = user;
    _storage.setString(KEY_ACCOUNT_ID, user?.id);
    _onAuthStateChangedController.add(user ?? UserAccount(""));
  }

  @override
  Stream<UserAccount> get onUserAccountChanged =>
      _onAuthStateChangedController.stream;

  @override
  dispose() {
    return _onAuthStateChangedController.close();
  }


}
