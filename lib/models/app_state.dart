import 'package:flutter_bitshares/home/home_actions.dart';
import 'package:flutter_bitshares/models/balance.dart';
import 'package:flutter_bitshares/models/model.dart';
import 'package:flutter_bitshares/navigation/app_routes.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final AppTab activeTab;
  final UserAccount currentAccount;
  final List<Balance> balance;
  final List<String> route;

  AppState({
    this.isLoading = false,
    this.activeTab = AppTab.account,
    this.currentAccount,
    this.balance = const [],
    this.route = const [AppRoutes.splash],
  });

  factory AppState.initial() => AppState();

  AppState copyWith(
    bool isLoading,
    AppTab activeTab,
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
