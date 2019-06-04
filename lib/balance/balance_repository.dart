import 'dart:async';

import 'package:flutter_bitshares/db.dart';

abstract class BalanceRepository {
  Stream<List<Balance>> get all;
  insertAll(List<Balance> balances);
  Stream<List<String>> get missingAssetIds;
}
