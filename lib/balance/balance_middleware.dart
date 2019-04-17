import 'package:flutter_bitshares/balance/balance_action.dart';
import 'package:flutter_bitshares/balance/balance_repository.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createBalanceMiddleware(
    BalanceRepository balanceRepositoy) {
  return [
    TypedMiddleware<AppState, LoadBalanceAction>(loadBalance(balanceRepositoy)),
  ];
}

void Function(
        Store<AppState> store, LoadBalanceAction action, NextDispatcher next)
    loadBalance(BalanceRepository repository) {
  return (store, action, next) {
    next(action);
    repository.getAll().listen((balances) {
      store.dispatch(BalanceLoadedAction(balances));
    });
  };
}
