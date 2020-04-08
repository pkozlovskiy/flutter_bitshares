import 'package:bloc/bloc.dart';
import 'package:flutter_wallet/core/error/exceptions.dart';
import 'package:flutter_wallet/features/balance/domain/repositories/balance_repository.dart';

import 'balance_event.dart';
import 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> with FailureMapper {
  final BalanceRepository repository;

  BalanceBloc(this.repository) {
    repository.balances.listen((data) {
      this.add(UpdateBalance(data));
    });
  }

  @override
  BalanceState get initialState => BalanceEmpty();

  @override
  Stream<BalanceState> mapEventToState(BalanceEvent event) async* {
    if (event is FetchBalance) {
      yield BalanceLoading();
      await repository.updateBalances();
    }
    if (event is UpdateBalance) {
      yield BalanceLoaded(event.balance);
    }
  }
}
