import 'package:flutter/material.dart';
import 'package:flutter_bitshares/login/bloc/bloc.dart';
import 'package:flutter_bitshares/login/sign_in_page.dart';
import 'package:flutter_bitshares/login/sign_up_page.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;

  const LoginScreen({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
