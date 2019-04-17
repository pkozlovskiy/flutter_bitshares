import 'package:flutter_bitshares/balance/balance_action.dart';
import 'package:flutter_bitshares/models/balance.dart';
import 'package:redux/redux.dart';

final balanceReducer = combineReducers<List<Balance>>([
  TypedReducer<List<Balance>, BalanceLoadedAction>(_setLoadedBalances),
]);

List<Balance> _setLoadedBalances(
    List<Balance> state, BalanceLoadedAction action) {
  // return action.balances;
  //TODO remove
  return [
    Balance('1', 1, 1),
    Balance('2', 2, 2),
    Balance('3', 3, 3),
    Balance('4', 4, 4),
  ];
}
