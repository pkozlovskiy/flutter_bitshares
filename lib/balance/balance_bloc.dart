import 'dart:async';

import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/db.dart';
import 'package:rxdart/rxdart.dart';

class BalanceBloc {
  final BalanceRepository balanceRepository;
  var _controller = StreamController<List<Balance>>();

  BalanceBloc(this.balanceRepository){
    // balanceRepository.getAll().listen((data)=>_controller.sink.add(event));
  }

  void dispose() {
    _controller.close();
  }
}
