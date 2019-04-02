import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitshares/pages/sign_in_page.dart';
import 'package:flutter_bitshares/pages/sign_up_page.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:flutter_bitshares/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final UserRepository userRepository;

  const LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthBloc _authBloc;
  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _loginBloc =
        LoginBloc(userRepository: _userRepository, authBloc: _authBloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: PageView(children: <Widget>[
        SignInPage(loginBloc: _loginBloc),
        SignUpPage(loginBloc: _loginBloc)
      ]),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthBloc authBloc;

  LoginBloc({@required this.userRepository, @required this.authBloc})
      : assert(userRepository != null),
        assert(authBloc != null);

  @override
  get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(
      LoginState currentState, LoginEvent event) async* {
    if (event is SignUpPressed) {
      yield LoginLoading();

      try {
        final wallet = await userRepository.signUp(
            username: event.username, pass: event.pass);
        authBloc.dispatch(SignUp(wallet: wallet));
      } catch (error) {
        yield LoginFail(error: error.toString());
      }
    }

    if (event is SignInPressed) {
      yield LoginLoading();

      try {
        final wallet = await userRepository.signIn(
            username: event.username, pass: event.pass);
        authBloc.dispatch(SignIn(wallet: wallet));
      } catch (error) {
        yield LoginFail(error: error.toString());
      }
    }
  }
}

class SignUpPressed extends LoginEvent {
  final pass;
  final username;

  SignUpPressed({@required this.username, @required this.pass})
      : super([username, pass]);
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
