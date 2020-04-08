import 'package:flutter_wallet/features/balance/domain/entities/balance_with_asset.dart';

abstract class BalanceRepository {
  Stream<List<BalanceWithAsset>> get balances;

  Future<void> updateBalances();

  Future<void> reset();
}
