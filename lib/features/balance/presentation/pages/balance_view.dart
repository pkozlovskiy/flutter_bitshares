import 'package:flutter/material.dart';
import 'package:flutter_wallet/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:flutter_wallet/features/balance/presentation/bloc/balance_event.dart';
import 'package:flutter_wallet/features/balance/presentation/bloc/balance_state.dart';
import 'package:flutter_wallet/features/balance/presentation/pages/balance_list.dart';
import 'package:flutter_wallet/keys.dart';
import 'package:provider/provider.dart';

class BalanceView extends StatefulWidget {
  @override
  _BalanceViewState createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> {
  @override
  void initState() {
    super.initState();
//    Provider.of<BalanceBloc>(context, listen: false).add(FetchBalance());
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<BalanceBloc>(context);
    return StreamBuilder(
      stream: bloc,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final state = snapshot.data;
        if (state is BalanceLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is BalanceLoaded) {
          final balance = state.balance;
          return RefreshIndicator(
            onRefresh: () => _refreshBalances(),
            child: BalanceList(
              key: Keys.balanceList,
              balances: balance,
            ),
          );
        }
        if (state is BalanceEmpty) {
          return Center(child: Text('Не '));
        }
        return Text('Неизветсный стейт');
      },
    );
  }

  _refreshBalances() {
    Provider.of<BalanceBloc>(context, listen: false).add(FetchBalance());
  }
}
