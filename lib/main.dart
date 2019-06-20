import 'package:flutter/material.dart';
import 'package:flutter_bitshares/app.dart';
import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/db.dart';
import 'package:flutter_bitshares/repository_facade.dart';
import 'package:flutter_bitshares/services/rpc/bitshares_websocket_service.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'balance/balance.dart';

Future main() async {
  _configureLogger();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var _networkService = BitsharesWebsocketService();
  var db = MyDatabase();
  var userRepository = UserRepositoryImp(_networkService, _prefs);

  var balanceRepository = BalanceRepositoryImpl(
      userRepository,
      BalanceCacheDataSourceImpl(db.balancesDao),
      BalanceRemoteDataSourceImpl(_networkService));

  runApp(App(
    RepositoryFacade(
      userRepository,
      balanceRepository,
    ),
  ));
}

void _configureLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord logRec) {
    if (bool.fromEnvironment("dart.vm.product") == false) {
      print(
          '[${logRec.level.name}][${logRec.time}][${logRec.loggerName}]: ${logRec.message}');
    }
  });
}
