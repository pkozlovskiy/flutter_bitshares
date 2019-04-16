import 'package:flutter/widgets.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Text('Auth');
      },
    );
  }
}

class _ViewModel {
  static _ViewModel fromStore(Store<AppState> store) {}
}
