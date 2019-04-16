import 'package:flutter_bitshares/auth/auth_actions.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAuthMiddleware(UserRepository userRepository) {
  
  return [
    TypedMiddleware<AppState, CheckAccount>(_checkAccount(userRepository)),
    TypedMiddleware<AppState, LogInAction>(_logInAction(userRepository)),
  ];
}

_checkAccount(UserRepository userRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is CheckAccount) {
      userRepository
          .isAuth()
          .then((iAuth) => iAuth ? action.hasAccount() : action.noAccaunt())
          .catchError((_) => action.noAccaunt());
      next(action);
    }
  };
}

_logInAction(UserRepository userRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is CheckAccount) {
      userRepository
          .isAuth()
          .then((iAuth) => iAuth ? action.hasAccount() : action.noAccaunt())
          .catchError((_) => action.noAccaunt);
      next(action);
    }
  };
}

// _signIn(UserRepository userRepository) {}

// void _checkAccounta(Store<AppState> store, CheckAccount action, NextDispatcher next) {
