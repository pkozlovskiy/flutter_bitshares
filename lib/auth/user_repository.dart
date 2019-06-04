import 'dart:async';

import 'package:flutter_bitshares/services/rpc/websocket_service.dart';
import 'package:graphened/graphened.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRepository {
  Future<UserAccount> signIn(String name, String password);
  Future<UserAccount> createUser(String name, String password);
  Future<void> signOut();
  Stream<UserAccount> get onUserAccountChanged;
}

class UserRepositoryImp extends UserRepository {
  final WebsocketService _service;
  static const String KEY_ACCOUNT_ID = 'KEY_ACCOUNT_ID';
  final SharedPreferences _storage;

  UserAccount _currentUser;
  StreamController _onAuthStateChangedController =
      StreamController<UserAccount>();

  UserRepositoryImp(this._service, this._storage) {
    var id = _storage.getString(KEY_ACCOUNT_ID);

    _onAuthStateChangedController.add(id != null ? UserAccount(id) : null);
  }

  @override
  Future<UserAccount> signIn(String username, String pass) async {
    Response response = await _service.call(GetAccountByName(username));
    var userAccount = UserAccount.fromJson(response.result);
    _add(userAccount);
    return userAccount;
  }

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
    Response response = await _service.call(GetAccountByName(username));
    return response.result != null
        ? UserAccount.fromJson(response.result)
        : null;
  }

  Future<UserAccount> createUser(String name, String password) {
    return null;
  }

  _add(UserAccount user) {
    _currentUser = user;
    _storage.setString(KEY_ACCOUNT_ID, user.id);
    _onAuthStateChangedController.add(user);
  }

  @override
  Stream<UserAccount> get onUserAccountChanged =>
      _onAuthStateChangedController.stream;
}
