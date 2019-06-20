import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bitshares/repository_facade.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final _nameController = TextEditingController(text: 'evraz-pako');
  final _passController = TextEditingController(text: 'Evraz1234567');

  @override
  Widget build(BuildContext context) {
    var userRepository = Provider.of<RepositoryFacade>(context).userRepository;

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
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
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
                      userRepository.signIn(_nameController.text, _passController.text);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
