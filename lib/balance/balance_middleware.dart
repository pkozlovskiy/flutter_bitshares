import 'package:flutter_bitshares/balance/balance_action.dart';
import 'package:flutter_bitshares/balance/balance_repository.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createBalanceMiddleware(
    BalanceRepository balanceRepositoy) {
  return [
    TypedMiddleware<AppState, LoadBalanceAction>(loadBalance),
  ];
}

void loadBalance(
    Store<AppState> store, LoadBalanceAction action, NextDispatcher next) {}
