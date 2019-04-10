import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MarketState extends Equatable {
  MarketState([Iterable props]) : super(props);

  /// Copy object for use in action
  MarketState getStateCopy();
}

/// UnInitialized
class UnMarketState extends MarketState {
  @override
  String toString() => 'UnMarketState';

  @override
  MarketState getStateCopy() {
    return UnMarketState();
  }
}

/// Initialized
class InMarketState extends MarketState {

  @override
  String toString() => 'InMarketState';

  @override
  MarketState getStateCopy() {
    return InMarketState();
  }
}

class ErrorMarketState extends MarketState {
  @override
  String toString() => 'ErrorMarketState';

  @override
  MarketState getStateCopy() {
    return ErrorMarketState();
  }
}
