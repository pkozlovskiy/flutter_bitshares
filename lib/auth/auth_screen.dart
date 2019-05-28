import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bitshares/app_state.dart';
import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/navigation/navigation_actions.dart';
import 'package:flutter_bitshares/navigation/navigation_routes.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

class AuthScreen extends StatelessWidget {
  var _nameController = TextEditingController(text: 'evraz-pako');
  var _passController = TextEditingController(text: 'Evraz1234567');

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset('assets/images/bitshares_logo.svg'),
                  ),
                  Text(
                    "",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Enter your username",
                          labelText: "Username",
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        obscureText: true,
                        controller: _passController,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          labelText: "Password",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          vm.onLogin(
                              _nameController.text, _passController.text);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Function(String name, String pass) onLogin;

  _ViewModel({@required this.onLogin});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onLogin: (name, pass) {
        var completer = Completer();
        completer.future.then((_) {
          store.dispatch(NavigateReplaceAction(NavigationRoutes.home));
        });
        store.dispatch(LogInAction(name, pass, completer));
      },
    );
  }
}
