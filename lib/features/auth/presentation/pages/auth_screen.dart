import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_wallet/core/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter_wallet/core/common_widgets/stream_listener_builder.dart';
import 'package:flutter_wallet/core/constants/navigation_routes.dart';
import 'package:flutter_wallet/core/constants/strings.dart';
import 'package:flutter_wallet/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_wallet/features/auth/presentation/bloc/auth_state.dart';
import 'package:provider/provider.dart';

import '../bloc/auth_bloc.dart';

class AuthScreen extends StatelessWidget {
  final _nameController = TextEditingController(text: 'evraz-pako');
  final _passController = TextEditingController(text: 'Evraz1234567');

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<AuthBloc>(context);
    return StreamListenableBuilder(
      stream: bloc,
      listener: (value) {
        if (value is AuthenticationAuthenticated) {
          Provider.of<GlobalKey<NavigatorState>>(context, listen: false)
              .currentState
              .pushReplacementNamed(NavigationRoutes.home);
        }
      },
      builder: (context, snapshot) {
        if (snapshot.data is AuthenticationError) {
          WidgetsBinding.instance.addPostFrameCallback((_) async => {
                await PlatformExceptionAlertDialog(
                  title: Strings.errror,
                  exception: PlatformException(code: '', message: ''),
//            content: snapshot.data.toString(),
//            defaultActionText: Strings.ok,
//            cancelActionText: Strings.cancel,
                ).show(context)
              });
        }

        if (snapshot.data is AuthenticationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

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
                          bloc.add(LoggedIn(
                              _nameController.text, _passController.text));
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
