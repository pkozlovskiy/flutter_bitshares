import 'package:bloc/bloc.dart';
import 'package:flutter_wallet/features/balance/domain/repositories/balance_repository.dart';

import '../../domain/repositories/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final BalanceRepository _balanceRepository;

  AuthBloc(this._userRepository, this._balanceRepository);

  void signIn(String name, String password) {
    _userRepository.signIn(name, password);
  }

  void signOut() {
    _userRepository.signOut();
  }

  @override
  get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is AppStarted) {
      var user = await _userRepository.user.first;
      final bool hasToken = (user != null);

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      try {
        await _userRepository.signIn(event.name, event.pass);
        yield AuthenticationAuthenticated();
      } catch (e) {
        yield AuthenticationError(e);
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await Future.wait([
        _balanceRepository.reset(),
        _userRepository.signOut(),
      ]);
      yield AuthenticationUnauthenticated();
    }
  }
}
