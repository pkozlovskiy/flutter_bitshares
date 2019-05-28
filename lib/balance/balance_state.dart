import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_bitshares/balance/balance.dart';
// STARTER: import - do not remove comment

part 'balance_state.g.dart';

abstract class BalanceState implements Built<BalanceState, BalanceStateBuilder> {
  List<Balance> get balances;

  // STARTER: fields - do not remove comment

  factory BalanceState() {
    return _$BalanceState._(
      balances: [],
      // STARTER: constructor - do not remove comment
    );
  }

  BalanceState._();
  // static Serializer<BalanceState> get serializer => _$balanceStateSerializer;
}