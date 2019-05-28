import 'package:flutter_bitshares/app_state.dart';
import 'package:flutter_bitshares/balance/balance.dart';

List<Balance> balanceSelector(AppState state) => state.balanceState.balances;
