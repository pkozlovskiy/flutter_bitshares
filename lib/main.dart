import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitshares/network_service.dart';
import 'package:flutter_bitshares/pages/home_page.dart';
import 'package:flutter_bitshares/pages/login_page.dart';
import 'package:flutter_bitshares/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

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
    _authBloc.dispatch(AppStarted());
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
            if (state is AuthUninit) {
              return SplashPage();
            }
            if (state is Authenticated || state is Registered) {
              return HomePage();
            }
            if (state is UnAuthenticated) {
              return LoginPage(userRepository: _userRepository);
            }
            if (state is AuthLoading) {
              return LoadingScreen();
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

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  AuthState get initialState => AuthUninit();

  @override
  Stream<AuthState> mapEventToState(
      AuthState currentState, AuthEvent event) async* {
    if (event is AppStarted) {
      final bool isAuth = await userRepository.isAuth();
      if (isAuth) {
        yield Authenticated();
      } else {
        yield UnAuthenticated();
      }
    }
    if (event is SignIn) {
      yield AuthLoading();
      await userRepository.auth(event.wallet);
      yield Authenticated();
    }
    if (event is SignUp) {
      yield AuthLoading();
      await userRepository.auth(event.wallet);
      yield Registered();
    }
    if (event is LoggedOut) {
      yield AuthLoading();
      await userRepository.signOut();
      yield UnAuthenticated();
    }
  }
}

class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthEvent {}

class SignIn extends AuthEvent {
  final String wallet;
  SignIn({@required this.wallet}) : super([wallet]);
}

class SignUp extends AuthEvent {
  final String wallet;
  SignUp({@required this.wallet}) : super([wallet]);
}

class LoggedOut extends AuthEvent {}

class AuthState extends Equatable {}

class AuthUninit extends AuthState {}

class AuthLoading extends AuthState {}

class UnAuthenticated extends AuthState {}

class Registered extends AuthState {}

class Authenticated extends AuthState {}
