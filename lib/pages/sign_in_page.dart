import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bitshares/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  final LoginBloc loginBloc;

  SignInPage({Key key, this.loginBloc}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  final _formKey = GlobalKey<FormState>();

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
                    if (value.isEmpty) {
                      return 'Enter password';
                    }
                  },
                  decoration:
                      InputDecoration(filled: true, labelText: 'Password'),
                  obscureText: true,
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                        child: Text('SIGNIN'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _loginBloc.dispatch(SignInPressed(
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
