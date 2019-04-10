import 'package:flutter/material.dart';
import 'package:flutter_bitshares/dashboard/bloc/bloc.dart';
import 'package:flutter_bitshares/dashboard/dashboard_screen.dart';
import 'package:flutter_bitshares/home/bloc/bloc.dart';
import 'package:flutter_bitshares/login/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tabBloc = TabBloc();

  DashboardBloc _dashboardBloc;

  int _index = 0;

  @override
  void initState() {
    _dashboardBloc = DashboardBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder(
      bloc: _tabBloc,
      builder: (BuildContext context, AppTab tab) {
        return BlocProviderTree(
          blocProviders: [
            BlocProvider<TabBloc>(bloc: _tabBloc),
            BlocProvider<DashboardBloc>(bloc: _dashboardBloc),
          ],
          child: Scaffold(
              appBar: AppBar(
                title: Text('Bitshares Wallet'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      authBloc.dispatch(LoggedOutEvent());
                    },
                  )
                ],
              ),
              body: tab == AppTab.account
                  ? DashboardScreen(dashboardBloc: _dashboardBloc)
                  : DashboardScreen(dashboardBloc: _dashboardBloc),
              bottomNavigationBar: TabSelector(
                  activeTab: tab,
                  onTabSelected: (tab) => _tabBloc.dispatch(UpdateTab(tab)))),
        );
      },
    );
  }
}

class TabSelector extends StatelessWidget {
  final AppTab activeTab;

  final Function(AppTab) onTabSelected;

  TabSelector({Key key, this.onTabSelected, this.activeTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet), title: Text("Account")),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance), title: Text("Exchange")),
      ],
    );
  }
}
