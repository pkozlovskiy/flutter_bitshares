import 'package:flutter_bitshares/auth/auth.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, LogInSuccessfulAction>(_logIn),
  TypedReducer<AuthState, LogOutSuccessfulAction>(_logOut),
]);
AuthState _logIn(AuthState state, LogInSuccessfulAction action) {
  return state.rebuild(
    (b) => b..currentAccount = action.user,
  );
}

AuthState _logOut(AuthState state, LogOutSuccessfulAction action) {
  return state.rebuild(
    (b) => b..currentAccount = null,
  );
}
