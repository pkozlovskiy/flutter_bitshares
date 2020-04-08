import 'dart:async';

import 'package:flutter_wallet/core/services/rpc/websocket_service.dart';
import 'package:flutter_wallet/features/auth/domain/repositories/user_repository.dart';
import 'package:graphened/graphened.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class UserRepositoryImp extends UserRepository {
  static const String KEY_ACCOUNT_ID = 'KEY_ACCOUNT_ID';
  final WebsocketService _service;
  final Box _box;
  BehaviorSubject<UserAccount> _subject = new BehaviorSubject();

  @override
  BehaviorSubject<UserAccount> get user => _subject;

  UserRepositoryImp(this._service, this._box) {
    var id = _box.get(KEY_ACCOUNT_ID);
    _add(id != null ? UserAccount(id) : null);
  }

  @override
  Future<UserAccount> signIn(String username, String pass) async {
    Response response = await _service.call(GetAccountByName(username));
    var userAccount = UserAccount.fromJson(response.result);
    _add(userAccount);
    return userAccount;
  }

  Future<void> signOut() {
    return _add(null);
  }

  Future<UserAccount> getUserAccount(String username) async {
    Response response = await _service.call(GetAccountByName(username));
    return response.result != null
        ? UserAccount.fromJson(response.result)
        : null;
  }

  _add(UserAccount user) {
    return _box
        .put(KEY_ACCOUNT_ID, user?.id)
        .then((value) async => _subject.add(user));
  }

  @override
  Future<void> dispose() {
    return Future.wait([
      _box.close(),
      _subject.close(),
    ]);
  }
}
