import 'package:flutter/material.dart';
import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/db.dart';
import 'package:flutter_bitshares/repository_facade.dart';
import 'package:provider/provider.dart';

class BalanceView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var balanceRepository = Provider.of<RepositoryFacade>(context).balanceRepository;

    return StreamBuilder<List<Balance>>(
      stream: balanceRepository.all,
      builder: (_, AsyncSnapshot<List<Balance>> snapshot) {
        final balances = snapshot.data;
        if (balances == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        return BalanceList(
          balances: balances,
        );
      },
    );
  }
}