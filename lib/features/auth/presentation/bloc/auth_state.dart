//abstract class LoginState extends Equatable {
//  const LoginState();
//
//  @override
//  List<Object> get props => [];
//}
//
//class LoginInitial extends LoginState {}
//
//class LoginLoading extends LoginState {}
//
//class LoginFailure extends LoginState {
//  final String error;
//
//  const LoginFailure({@required this.error});
//
//  @override
//  List<Object> get props => [error];
//
//  @override
//  String toString() => 'LoginFailure { error: $error }';
//}

abstract class AuthenticationState {}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final Error error;

  AuthenticationError(this.error);
}
