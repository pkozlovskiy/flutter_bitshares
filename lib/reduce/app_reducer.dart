import 'package:flutter_bitshares/auth/auth_reducer.dart';
import 'package:flutter_bitshares/balance/balance_reducer.dart';
import 'package:flutter_bitshares/home/home_tabs_reducer.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:flutter_bitshares/navigation/navigation_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    currentAccount: authReducer(state.currentAccount, action),
    balance: balanceReducer(state.balance, action),
    route: navigationReducer(state.route, action),
    activeTab: tabsReducer(state.activeTab,action),
  );
}
