import 'dart:async';
import 'package:flutter_bitshares/network_service.dart';
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final NetworkService service;
  static const String KEY_ACCOUNT_ID = 'KEY_ACCOUNT_ID';
  final _storage = FlutterSecureStorage();

  UserRepository(this.service);

  Future<bool> isAuth() async {
    String wallet = await _storage.read(
      key: KEY_ACCOUNT_ID,
    );
    return wallet != null;
  }

  Future<String> signIn(
      {@required String username, @required String pass}) async {
    await _storage.write(key: KEY_ACCOUNT_ID, value: 'wallet');

    return 'wallet';
  }

  Future<String> signUp(
      {@required String username, @required String pass}) async {
    await _storage.write(key: KEY_ACCOUNT_ID, value: 'wallet');

    return 'wallet';
  }

  Future<void> auth(String wallet) async {
    await _storage.write(key: KEY_ACCOUNT_ID, value: wallet);
    return;
  }

  Future<void> signOut() async {
    await _storage.delete(key: KEY_ACCOUNT_ID);
    return;
  }
}
