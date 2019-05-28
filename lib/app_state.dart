
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/home/home.dart';
import 'package:flutter_bitshares/navigation/navigation.dart';

// STARTER: import - do not remove comment
part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  bool get isLoading;
  AuthState get authState;
  // UIState get uiState;
  BalanceState get balanceState;
  HomeBottomTab get activeTab;
  List<String> get route;

  factory AppState() {
    return _$AppState._(
      isLoading: false,
      authState: AuthState(),
      // uiState: UIState(),
      balanceState: BalanceState(),
      activeTab: HomeBottomTab.account,
      route: [NavigationRoutes.splash]
    );
  }

  AppState._();
  static Serializer<AppState> get serializer => _$appStateSerializer;

  // EntityUIState getUIState(EntityType type) {
  //   switch (type) {
  //     // STARTER: states switch - do not remove comment
  //     default:
  //       return null;
  //   }
  // }

  // ListUIState getListState(EntityType type) {
  //   return getUIState(type).listUIState;
  // }

  // STARTER: state getters - do not remove comment

  /*
  @override
  String toString() {
    return 'Is Loading: ${this.isLoading}';
  }
  */
}