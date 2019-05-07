import 'package:flutter/material.dart';
import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/keys.dart';

class BalanceList extends StatelessWidget {
  final List<Balance> balances;
  final Function(Balance) onAsset;
  final Function(Balance) onSend;
  final Function(Balance) onTrade;

  const BalanceList({
    Key key,
    this.balances,
    this.onAsset,
    this.onSend,
    this.onTrade,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: Keys.balanceList,
      itemCount: balances.length,
      itemBuilder: (context, index) {
        var balance = balances[index];
        return BalanceItem(
          balance: balance,
        );
      },
    );
  }
}

class BalanceItem extends StatelessWidget {
  final Balance balance;
  final Function(Balance) onAsset;
  final Function(Balance) onSend;
  final Function(Balance) onTrade;

  BalanceItem({
    this.balance,
    this.onAsset,
    this.onSend,
    this.onTrade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(balance.assetAmount.toString()),
          subtitle: Text(balance.asset_id),
        ),
        Divider(
          height: 2,
          color: Colors.grey,
        )
      ],
    );
  }
}
