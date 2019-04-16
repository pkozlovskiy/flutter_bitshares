import 'package:flutter_bitshares/auth/auth_actions.dart';
import 'package:flutter_bitshares/models/model.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<UserAccount>([
  TypedReducer<UserAccount, LogInSuccessfulAction>(_logIn),
  TypedReducer<UserAccount, LogOutSuccessfulAction>(_logOut),
]);
UserAccount _logIn(UserAccount state, LogInSuccessfulAction action) {
  return action.user;
}

UserAccount _logOut(UserAccount state, LogOutSuccessfulAction action) {
  return null;
}
