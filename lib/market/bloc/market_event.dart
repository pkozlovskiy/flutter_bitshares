import 'dart:async';
import 'package:flutter_bitshares/market/bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MarketEvent {
  Future<MarketState> applyAsync({MarketState currentState, MarketBloc bloc});
}

class LoadMarketEvent extends MarketEvent {
  @override
  String toString() => 'LoadMarketEvent';

  @override
  Future<MarketState> applyAsync(
      {MarketState currentState, MarketBloc bloc}) async {
    try {
      await Future.delayed(new Duration(seconds: 2));
      return new InMarketState();
    } catch (_) {
      print(_);
      return new ErrorMarketState();
    }
  }
}
