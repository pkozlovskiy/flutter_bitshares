import 'package:equatable/equatable.dart';
import 'package:flutter_wallet/features/balance/domain/entities/balance_with_asset.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BalanceState {}

class BalanceEmpty extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceLoaded extends BalanceState with EquatableMixin {
  final List<BalanceWithAsset> balance;

  BalanceLoaded(@required this.balance);

  @override
  List<Object> get props => [balance];
}

class BalanceError extends BalanceState with EquatableMixin {
  final String message;

  BalanceError({@required this.message});

  @override
  List<Object> get props => [message];
}
