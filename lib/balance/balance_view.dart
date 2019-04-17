import 'package:flutter/material.dart';
import 'package:flutter_bitshares/balance/balance_action.dart';
import 'package:flutter_bitshares/balance/balance_list.dart';
import 'package:flutter_bitshares/balance/balance_selector.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:flutter_bitshares/models/model.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BalanceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        Future.delayed(const Duration(seconds: 1),
            () => store.dispatch(BalanceLoadedAction([]))); //TODO remove
      },
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return BalanceList(
          balances: vm.balances,
          onAsset: vm.onAsset,
          onSend: vm.onSend,
          onTrade: vm.onTrade,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Balance> balances;
  final Function(Balance) onAsset;
  final Function(Balance) onSend;
  final Function(Balance) onTrade;

  _ViewModel({
    @required this.balances,
    @required this.onAsset,
    @required this.onSend,
    @required this.onTrade,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      balances: balanceSelector(store.state),
      onAsset: (balance) {
        var balance;
        store.dispatch(ShowBalanceAssetInfoAction(balance.asset_id));
      },
      onSend: (balance) {
        store.dispatch(SendAssetAction(balance.asset_id));
      },
      onTrade: (balance) {
        store.dispatch(TradeAssetAction(balance.asset_id));
      },
    );
  }
}
