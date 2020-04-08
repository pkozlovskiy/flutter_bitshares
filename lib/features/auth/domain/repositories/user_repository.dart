import 'package:graphened/graphened.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserRepository {
  BehaviorSubject<UserAccount> get user;

  Future<UserAccount> signIn(String name, String password);

  Future<void> signOut();

  Future<void> dispose();
}
