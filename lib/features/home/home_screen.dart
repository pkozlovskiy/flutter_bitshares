import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_wallet/core/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_wallet/core/common_widgets/stream_listener_builder.dart';
import 'package:flutter_wallet/core/constants/navigation_routes.dart';
import 'package:flutter_wallet/core/constants/strings.dart';
import 'package:flutter_wallet/features/activity/activity_view.dart';
import 'package:flutter_wallet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_wallet/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_wallet/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_wallet/features/balance/presentation/pages/balance_view.dart';
import 'package:flutter_wallet/features/buy/buy_view.dart';
import 'package:flutter_wallet/features/orders/orders_view.dart';
import 'package:flutter_wallet/keys.dart';
import 'package:provider/provider.dart';

import 'home_bottom_tabs.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: Keys.homeScreen);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  StreamController<HomeBottomTab> tabController;
  TabController _controller;

  @override
  void initState() {
    super.initState();

    tabController = StreamController<HomeBottomTab>();
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController.close();
    super.dispose();
  }

  Future<void> _confirmSignOut() async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      Provider.of<AuthBloc>(context, listen: false).add(LoggedOut());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamListenableBuilder(
      stream: Provider.of<AuthBloc>(context),
      listener: (state) {
        if (state is AuthenticationUnauthenticated) {
          Provider.of<GlobalKey<NavigatorState>>(context, listen: false)
              .currentState
              .pushReplacementNamed(NavigationRoutes.auth);
        }
      },
      builder: (context, snapshot) => StreamBuilder<HomeBottomTab>(
        initialData: HomeBottomTab.account,
        stream: tabController.stream,
        builder: (context, activeTabSnapshot) {
          _controller = new TabController(length: 2, vsync: this);
          return Scaffold(
            appBar: AppBar(
                title: Text('Wallet'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      Strings.logout,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _confirmSignOut(),
                  ),
                ],
                bottom: activeTabSnapshot.data != HomeBottomTab.test
                    ? TabBar(
                        controller: _controller,
                        tabs: activeTabSnapshot.data == HomeBottomTab.account
                            ? <Widget>[
                                Tab(text: 'Balance'),
                                Tab(text: 'Activity'),
                              ]
                            : activeTabSnapshot.data == HomeBottomTab.market
                                ? <Widget>[
                                    Tab(text: 'Orders'),
                                    Tab(text: 'Buy'),
                                  ]
                                : [Tab(text: 'Orders')])
                    : null),
            body: TabBarView(
              controller: _controller,
              children: activeTabSnapshot.data == HomeBottomTab.account
                  ? <Widget>[
                      BalanceView(),
                      ActivityView(),
                    ]
                  : activeTabSnapshot.data == HomeBottomTab.market
                      ? <Widget>[
                          OrdersView(),
                          BuyView(),
                        ]
                      : [BalanceView()],
            ),
            bottomNavigationBar: BottomNavigationBar(
              key: Keys.homeTabs,
              currentIndex:
                  HomeBottomTab.values.indexOf(activeTabSnapshot.data),
              onTap: (index) {
                tabController.add(HomeBottomTab.values[index]);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet),
                    title: Text("Account")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance), title: Text("Exchange")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.date_range), title: Text("Test")),
              ],
            ),
          );
        },
      ),
    );
  }
}
