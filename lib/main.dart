import 'package:bloc/bloc.dart';
import 'package:flutter_bitshares/login/bloc/bloc.dart';
import 'package:flutter_bitshares/login/login_screen.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitshares/home/home_screen.dart';
import 'package:flutter_bitshares/network_service.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Logger log = Logger('Main');

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    log.info(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    log.warning(error);
  }
}

void main() {
  _configureLogger();
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(BitsharesWalletApp(userRepository: UserRepository(NetworkService())));
}

class BitsharesWalletApp extends StatefulWidget {
  final UserRepository userRepository;

  BitsharesWalletApp({Key key, @required this.userRepository})
      : super(key: key);

  @override
  State<BitsharesWalletApp> createState() => _AppState();
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

_configureThemeData() {
  return ThemeData(
    primarySwatch: Colors.lightBlue,
    textTheme: TextTheme(
        title: TextStyle(fontSize: 30, color: Colors.white),
        subtitle: TextStyle(fontSize: 20, color: Colors.white),
        body1: TextStyle(fontSize: 15, color: Colors.white)),
  );
}

class _AppState extends State<BitsharesWalletApp> {
  AuthBloc _authBloc;

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(userRepository: _userRepository);
    _authBloc.dispatch(AppStartedEvent());
  }

  @override
  void dispose() {
    _authBloc.dispose();
    NetworkService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: _authBloc,
      child: MaterialApp(
        theme: _configureThemeData(),
        title: 'Bitshares Wallet',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthEvent, AuthState>(
          bloc: _authBloc,
          builder: (BuildContext context, AuthState state) {
            if (state is AuthUninitState) {
              return SplashPage();
            }
            if (state is AuthenticatedState || state is RegisteredState) {
              return HomeScreen();
            }
            if (state is UnAuthenticatedState) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is AuthLoadingState) {
              return LoadingPage();
            }
          },
        ),
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SvgPicture.asset('assets/images/bitshares_logo.svg'),
    ));
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
