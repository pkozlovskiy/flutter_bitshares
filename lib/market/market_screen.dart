import 'package:flutter/material.dart';
import 'package:flutter_bitshares/market/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({
    Key key,
    @required MarketBloc marketBloc,
  })  : _marketBloc = marketBloc,
        super(key: key);

  final MarketBloc _marketBloc;

  @override
  MarketScreenState createState() {
    return new MarketScreenState(_marketBloc);
  }
}

class MarketScreenState extends State<MarketScreen> {
  final MarketBloc _marketBloc;
  MarketScreenState(this._marketBloc);

  @override
  void initState() {
    super.initState();
    this._marketBloc.dispatch(LoadMarketEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketEvent, MarketState>(
        bloc: widget._marketBloc,
        builder: (
          BuildContext context,
          MarketState currentState,
        ) {
          if (currentState is UnMarketState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return new Container(
              child: new Center(
            child: new Text("MarketScreen"),
          ));
        });
  }
}
