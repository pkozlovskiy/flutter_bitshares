import 'package:flutter_bitshares/app_state.dart';
import 'package:flutter_bitshares/auth/auth.dart';
import 'package:graphened/graphened.dart';
import 'package:graphened/src/user_account.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

final Logger log = Logger('AuthMiddleware');
List<Middleware<AppState>> createAuthMiddleware(UserRepository userRepository) {
  return [
    TypedMiddleware<AppState, CheckAccount>(_checkAccount(userRepository)),
    TypedMiddleware<AppState, LogInAction>(_logInAction(userRepository)),
    TypedMiddleware<AppState, LogOutAction>(_logOutAction(userRepository)),
  ];
}

_checkAccount(UserRepository userRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    userRepository
        .isAuth()
        .then((id) => (id != null && id.isNotEmpty)
            ? action.completer.complete(UserAccount(id))
            : action.completer.complete(null))
        .catchError((_) => action.completer.complete(null));
    next(action);
  };
}

_logInAction(UserRepository userRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    userRepository
        .signIn(username: action.username, pass: action.pass)
        .then((data) {
      _saveLocal(userRepository, data);
      store.dispatch(LogInSuccessfulAction(user: data));
      action.completer.complete(null);
    }).catchError((error) {
      log.info(error);
    });
    next(action);
  };
}

void _saveLocal(UserRepository userRepository, UserAccount data) {
  userRepository.auth(data);
}

_logOutAction(UserRepository userRepository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    userRepository.signOut().then((data) {
      store.dispatch(LogOutSuccessfulAction());
    }).catchError((error) {
      log.info(error);
    });
    next(action);
  };
}
