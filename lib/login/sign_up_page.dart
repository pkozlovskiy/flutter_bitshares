import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bitshares/login/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  final LoginBloc loginBloc;

  SignUpPage({Key key, this.loginBloc}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  final _formKey = GlobalKey<FormState>();
  final format1 = RegExp(".*[A-Z]+.*");
  final format2 = RegExp(".*[a-z]+.*");
  final format3 = RegExp(".*[0-9]+.*");

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          if (state is LoginFail) {
            _onWidgetDidBuild(() {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ));
            });
          }
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                    autofocus: false,
                    controller: _usernameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter username';
                      }
                    },
                    maxLines: 1,
                    decoration:
                        InputDecoration(filled: true, labelText: 'Username')),
                TextFormField(
                  controller: _passwordController,
                  maxLines: 1,
                  validator: (value) {
                    if (value.length < 8)
                      return 'Password lenth must be at least 8 symbols';
                    if (!format1.hasMatch(value))
                      return 'Password must contains uppercase';
                    if (!format2.hasMatch(value))
                      return 'Password must contains lowercase';
                    if (!format3.hasMatch(value))
                      return 'Password must contains digits';
                  },
                  decoration:
                      InputDecoration(filled: true, labelText: 'Password'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _passwordConfirmController,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords must be the same';
                    }
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      filled: true, labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                        child: Text('SIGNUP'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _loginBloc.dispatch(SignUpPressed(
                                username: _usernameController.text,
                                pass: _passwordController.text));
                          }
                        }),
                  ],
                )
              ],
            ),
          );
        });
  }
}

void _onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
