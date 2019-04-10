import 'dart:async';
import 'package:flutter_bitshares/models/api/api.dart';
import 'package:flutter_bitshares/models/user_account.dart';
import 'package:flutter_bitshares/network_service.dart';
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final NetworkService service;
  static const String KEY_ACCOUNT_ID = 'KEY_ACCOUNT_ID';
  final _storage = FlutterSecureStorage();

  UserRepository(this.service);

  Future<bool> isAuth() async {
    String id = await _storage.read(
      key: KEY_ACCOUNT_ID,
    );
    return id != null;
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
    await _storage.write(key: KEY_ACCOUNT_ID, value: userAccount.id);
    return;
  }

  Future<void> signOut() async {
    await _storage.delete(key: KEY_ACCOUNT_ID);
    return;
  }

  Future<UserAccount> getUserAccount(String username) async {
    Response response = await service.call(GetAccountByName(username));
    return response.result != null
        ? UserAccount.fromJson(response.result)
        : null;
  }
}
