import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/home/home.dart';
import 'package:flutter_bitshares/navigation/navigation.dart';
import 'package:graphened/graphened.dart';
import 'package:meta/meta.dart';

AppState appReducer(AppState state, action) => AppState(
      currentAccount: authReducer(state.currentAccount, action),
      balance: balanceReducer(state.balance, action),
      route: navigationReducer(state.route, action),
      activeTab: tabsReducer(state.activeTab, action),
    );

@immutable
class AppState {
  final bool isLoading;
  final HomeBottomTab activeTab;
  final UserAccount currentAccount;
  final List<Balance> balance;
  final List<String> route;

  AppState({
    this.isLoading = false,
    this.activeTab = HomeBottomTab.account,
    this.currentAccount,
    this.balance = const [],
    this.route = const [NavigationRoutes.splash],
  });

  factory AppState.initial() => AppState();

  AppState copyWith(
    bool isLoading,
    HomeBottomTab activeTab,
    UserAccount currentAccount,
    List<Balance> balance,
  ) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      activeTab: activeTab ?? this.activeTab,
      currentAccount: currentAccount ?? currentAccount,
      balance: balance ?? balance,
      route: route ?? route,
    );
  }

  @override
  int get hashCode =>
      route.hashCode ^
      isLoading.hashCode ^
      activeTab.hashCode ^
      currentAccount.hashCode ^
      balance.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          activeTab == other.activeTab &&
          currentAccount == other.currentAccount &&
          route == other.route &&
          balance == other.balance;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, activeTab: $activeTab, currentAccount: $currentAccount, balance: $balance, route: $route}';
  }
}
