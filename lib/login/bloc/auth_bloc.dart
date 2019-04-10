import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bitshares/models/user_account.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  AuthState get initialState => AuthUninitState();

  @override
  Stream<AuthState> mapEventToState(
       AuthEvent event) async* {
    if (event is AppStartedEvent) {
      final bool isAuth = await userRepository.isAuth();
      if (isAuth) {
        yield AuthenticatedState();
      } else {
        yield UnAuthenticatedState();
      }
    }
    if (event is SignInEvent) {
      yield AuthLoadingState();
      await userRepository.auth(event.userAccount);
      yield AuthenticatedState();
    }
    if (event is SignUpEvent) {
      yield AuthLoadingState();
      await userRepository.auth(event.userAccount);
      yield RegisteredState();
    }
    if (event is LoggedOutEvent) {
      yield AuthLoadingState();
      await userRepository.signOut();
      yield UnAuthenticatedState();
    }
  }
}

class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class AppStartedEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  UserAccount userAccount;

  SignInEvent(this.userAccount);
}

class SignUpEvent extends AuthEvent {
  UserAccount userAccount;

  SignUpEvent(this.userAccount);
}

class LoggedOutEvent extends AuthEvent {}

class AuthState extends Equatable {}

class AuthUninitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class UnAuthenticatedState extends AuthState {}

class RegisteredState extends AuthState {}

class AuthenticatedState extends AuthState {}
