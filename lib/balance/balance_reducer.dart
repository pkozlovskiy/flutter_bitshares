import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/balance/balance_action.dart';
import 'package:redux/redux.dart';

final balanceReducer = combineReducers<List<Balance>>([
  TypedReducer<List<Balance>, BalanceLoadedAction>(_setLoadedBalances),
]);

List<Balance> _setLoadedBalances(
    List<Balance> state, BalanceLoadedAction action) {
  return action.balances;
}
