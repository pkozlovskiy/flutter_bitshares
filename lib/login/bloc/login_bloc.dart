import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bitshares/login/bloc/bloc.dart';
import 'package:flutter_bitshares/models/model.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthBloc authBloc;

  LoginBloc({@required this.userRepository, @required this.authBloc})
      : assert(userRepository != null),
        assert(authBloc != null);

  @override
  get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UsernameChanged) {
      // var userAccount = await userRepository.getUserAccount(event.username);
      // if (userAccount != null) {
      //   yield UsernameExist(userAccount);
      // }
    } else if (event is SignUpPressed) {
      yield LoginLoading();

      try {
        final userAccount = await userRepository.signUp(
            username: event.username, pass: event.pass);
        authBloc.dispatch(SignUpEvent(userAccount));
      } catch (error) {
        yield LoginFail(error: error.toString());
      }
    } else if (event is SignInPressed) {
      yield LoginLoading();

      try {
        final userAccount = await userRepository.signIn(
            username: event.username, pass: event.pass);
        authBloc.dispatch(SignInEvent(userAccount));
      } catch (error) {
        yield LoginFail(error: error.toString());
      }
    }
  }

  void validateUsername(String value) {}

  void validatePassword(String value) {}
}

class PasswordChanged extends LoginEvent {
  String password;

  PasswordChanged(this.password);
}

class UsernameChanged extends LoginEvent {
  String username;

  UsernameChanged(this.username);
}

class SignUpPressed extends LoginEvent {
  final pass;
  final username;

  SignUpPressed({@required this.username, @required this.pass})
      : super([username, pass]);
}

class UsernameExist extends LoginState {
  final UserAccount userAccount;
  UsernameExist(this.userAccount);
}

class LoginFail extends LoginState {
  final String error;
  LoginFail({@required this.error}) : super([error]);
}

class LoginLoading extends LoginState {}

class SignInPressed extends LoginEvent {
  final pass;
  final username;

  SignInPressed({@required this.username, @required this.pass})
      : super([username, pass]);
}

class LoginInit extends LoginState {}

class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}
