import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/rpc/bitshares_websocket_service.dart';
import 'database/database/shared.dart';
import 'features/auth/data/repositories/user_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/balance/data/repositories/balance_repository.dart';
import 'features/balance/presentation/bloc/balance_bloc.dart';
import 'plugins/desktop/desktop.dart';

Future main() async {
  setTargetPlatformForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
//  BlocSupervisor.delegate = SimpleBlocDelegate();
  var _networkService = BitsharesWebsocketService();
  var db = constructDb();

  final file = File('hive');
  Hive.init(file.path);
  var box = await Hive.openBox('user');
  var userRepository = UserRepositoryImp(_networkService, box);

  var balanceRepository = BalanceRepositoryImpl(
      userRepository,
      BalanceCacheDataSourceImpl(db.balancesDao, db.assetsDao),
      BalanceRemoteDataSourceImpl(_networkService));

  runApp(
    App([
      StreamProvider<ConnectivityResult>(
        create: (context) => Connectivity().onConnectivityChanged,
      ),
      Provider<BalanceBloc>(
        create: (context) => BalanceBloc(balanceRepository),
        dispose: (context, value) => value.close(),
      ),
      Provider<AuthBloc>(
        create: (context) => AuthBloc(userRepository, balanceRepository),
        dispose: (context, value) => value.close(),
      ),
    ]),
  );
}

class SimpleBlocDelegate extends BlocDelegate {
  var logger = Logger();

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    logger.d(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.d(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    logger.d('$error, $stacktrace');
  }
}
