import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bitshares/activity/activity_view.dart';
import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/buy/buy_view.dart';
import 'package:flutter_bitshares/common_widgets/platform_alert_dialog.dart';
import 'package:flutter_bitshares/constants/strings.dart';
import 'package:flutter_bitshares/home/home.dart';
import 'package:flutter_bitshares/keys.dart';
import 'package:flutter_bitshares/orders/orders_view.dart';
import 'package:provider/provider.dart';

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

  Future<void> _signOut(BuildContext context) async {
    try {
      final UserRepository auth =
          Provider.of<UserRepository>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeBottomTab>(
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
                onPressed: () => _confirmSignOut(context),
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
                : null,
          ),
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
            currentIndex: HomeBottomTab.values.indexOf(activeTabSnapshot.data),
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
    );
  }
}
