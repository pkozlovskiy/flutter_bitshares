import 'package:flutter/material.dart';
import 'package:flutter_bitshares/activity/activity_view.dart';
import 'package:flutter_bitshares/balance/balance_view.dart';
import 'package:flutter_bitshares/buy/buy_view.dart';
import 'package:flutter_bitshares/home/home_actions.dart';
import 'package:flutter_bitshares/keys.dart';
import 'package:flutter_bitshares/models/app_state.dart';
import 'package:flutter_bitshares/orders/orders_view.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: Keys.homeScreen);
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _controller;

    return StoreConnector<AppState, AppTab>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.activeTab,
      builder: (BuildContext context, AppTab activeTab) {
        _controller = new TabController(length: 2, vsync: this);
        return Scaffold(
          appBar: AppBar(
            bottom: activeTab != AppTab.test
                ? TabBar(
                    controller: _controller,
                    tabs: activeTab == AppTab.account
                        ? <Widget>[
                            Tab(text: 'Balance'),
                            Tab(text: 'Activity'),
                          ]
                        : activeTab == AppTab.market
                            ? <Widget>[
                                Tab(text: 'Orders'),
                                Tab(text: 'Buy'),
                              ]
                            : [Tab(text: 'Orders')])
                : null,
          ),
          body: TabBarView(
            controller: _controller,
            children: activeTab == AppTab.account
                ? <Widget>[
                    BalanceView(),
                    ActivityView(),
                  ]
                : activeTab == AppTab.market
                    ? <Widget>[
                        OrdersView(),
                        BuyView(),
                      ]
                    : [BalanceView()],
          ),
          bottomNavigationBar: TabSelector(),
        );
      },
    );

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
  }
}

class TabSelector extends StatelessWidget {
  TabSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return BottomNavigationBar(
          key: Keys.homeTabs,
          currentIndex: AppTab.values.indexOf(vm.activeTab),
          onTap: vm.onTabSelected,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                title: Text("Account")),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance), title: Text("Exchange")),
            BottomNavigationBarItem(
                icon: Icon(Icons.date_range), title: Text("Test")),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final AppTab activeTab;
  final Function(int) onTabSelected;

  _ViewModel({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      activeTab: store.state.activeTab,
      onTabSelected: (index) {
        store.dispatch(UpdateHomeTabAction((AppTab.values[index])));
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeTab == other.activeTab;

  @override
  int get hashCode => activeTab.hashCode;
}
