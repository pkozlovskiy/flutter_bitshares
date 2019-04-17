import 'dart:async';

import 'package:flutter_bitshares/models/balance.dart';

abstract class BalanceRepository {
  Stream<List<Balance>> getAll();
  insertAll(List<Balance> balances);
  Stream<List<Balance>> getMisssingAssetIds();
}

class BalanceRepositoryImpl extends BalanceRepository {
  var _controller = StreamController<List<Balance>>();
  @override
  Stream<List<Balance>> getAll() {
    return _controller.stream;
  }

  insertAll(List<Balance> balances) {
    _controller.sink.add(balances);
  }

  Stream<List<Balance>> getMisssingAssetIds() {
    // TODO: implement balance
    return null;
  }
}
