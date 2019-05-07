import 'dart:async';

import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/services/rpc/bitshares_websocket_service.dart';
import 'package:flutter_bitshares/services/rpc/websocket_service.dart';
import 'package:graphened/graphened.dart';

abstract class BalanceRepository {
  Stream<List<Balance>> getAll(UserAccount currentAccount);
  insertAll(List<Balance> balances);
  Stream<List<Balance>> getMisssingAssetIds();
}

class BalanceRepositoryImpl extends BalanceRepository {
  final WebsocketService networkService;

  var _controller = StreamController<List<Balance>>();

  BalanceRepositoryImpl(BitsharesWebsocketService this.networkService);
  @override
  Stream<List<Balance>> getAll(UserAccount currentAccount) {
    _update(currentAccount);
    return _controller.stream;
  }

  insertAll(List<Balance> balances) {
    _controller.sink.add(balances);
  }

  Stream<List<Balance>> getMisssingAssetIds() {
    // TODO: implement balance
    return null;
  }

  Future _update(UserAccount currentAccount) async {
    Response response = await networkService.call(GetAccountBalances(currentAccount, []));
  }
}
