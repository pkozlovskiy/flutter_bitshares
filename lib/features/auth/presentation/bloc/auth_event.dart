import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent with EquatableMixin {
  final String name;
  final String pass;

  LoggedIn(this.name, this.pass);

  @override
  List<Object> get props => [name, pass];
}

class LoggedOut extends AuthenticationEvent {}
