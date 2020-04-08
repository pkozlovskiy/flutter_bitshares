import 'package:equatable/equatable.dart';
import 'package:flutter_wallet/features/balance/domain/entities/balance_with_asset.dart';

abstract class BalanceEvent {}

class FetchBalance extends BalanceEvent {}

class UpdateBalance extends BalanceEvent with EquatableMixin {
  final List<BalanceWithAsset> balance;

  UpdateBalance(this.balance);

  @override
  List<Object> get props => [balance];
}
