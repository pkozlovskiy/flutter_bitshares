import 'dart:async';
import 'dart:ui';

import 'package:graphened/graphened.dart';
import 'package:meta/meta.dart';

class CheckAccount {
  final Completer<UserAccount> completer;

  CheckAccount(this.completer);
}

class LogInAction {
  final Completer completer;
  final String username;
  final String pass;
  LogInAction(this.username, this.pass, this.completer);
}

class LogInSuccessfulAction {
  final UserAccount user;

  LogInSuccessfulAction({@required this.user});

  @override
  String toString() {
    return 'LogIn{user: $user}';
  }
}

class LogInFailAction {
  final dynamic error;
  LogInFailAction(this.error);
  @override
  String toString() {
    return 'LogIn{There was an error logging in: $error}';
  }
}

class LogOutAction {}

class LogOutSuccessfulAction {
  LogOutSuccessfulAction();
  @override
  String toString() {
    return 'LogOut{user: null}';
  }
}

class LogOutFailAction {
  final dynamic error;
  LogOutFailAction(this.error);
  String toString() {
    return '{There was an error logging out: $error}';
  }
}
