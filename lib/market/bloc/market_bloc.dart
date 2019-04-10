import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bitshares/market/bloc/bloc.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  static final MarketBloc _marketBlocSingleton = new MarketBloc._internal();
  factory MarketBloc() {
    return _marketBlocSingleton;
  }
  MarketBloc._internal();
  
  MarketState get initialState => new UnMarketState();

  @override
  Stream<MarketState> mapEventToState(
    MarketEvent event,
  ) async* {
    try{
      yield await event.applyAsync(currentState: currentState, bloc: this);
    }
    catch(e){
      print(e);
      yield currentState;
    }
  }
}
