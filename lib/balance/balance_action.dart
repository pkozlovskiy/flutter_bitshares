import 'package:flutter_bitshares/models/model.dart';

class LoadBalanceAction {}

class BalanceLoadedAction {
  final List<Balance> balances;
  BalanceLoadedAction(this.balances);
}

class SendAssetAction {
  SendAssetAction(String asset_id);
}

class ShowBalanceAssetInfoAction {
  ShowBalanceAssetInfoAction(asset_id);
}

class TradeAssetAction {
  TradeAssetAction(String asset_id);
}
