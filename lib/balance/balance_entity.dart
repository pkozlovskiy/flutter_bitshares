import 'package:built_value/built_value.dart';

part 'balance_entity.g.dart';

abstract class Balance implements Built<Balance, BalanceBuilder> {
  String get asset_id;
  int get assetAmount;
  int get last_update;

  factory Balance() {
    return _$Balance._(
      asset_id: '',
      assetAmount: 0,
      last_update: 0,
    );
  }

  Balance._();
}
