import 'dart:async';

import 'package:flutter_bitshares/app_state.dart';
import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/auth/user_repository.dart';
import 'package:flutter_bitshares/balance/balance.dart';
import 'package:flutter_bitshares/navigation/navigation.dart';
import 'package:flutter_bitshares/home/home_screen.dart';
import 'package:flutter_bitshares/services/rpc/bitshares_websocket_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:graphened/graphened.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_logging/redux_logging.dart';

final Logger log = Logger('Main');
final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  _configureLogger();
  var store = await _createStore();
  runApp(App(store: store));
}

Future<Store<AppState>> _createStore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _networkService = BitsharesWebsocketService();
  var userRepository = UserRepository(_networkService, prefs);
  var balanceRepository = BalanceRepositoryImpl(_networkService);
  return Store<AppState>(
    appReducer,
    middleware: [
      ...createAuthMiddleware(userRepository),
      ...createNavigationMiddleware(navigatorKey),
      ...createBalanceMiddleware(balanceRepository),
      LoggingMiddleware.printer()
    ],
    initialState: AppState(),
  );
}

AppState appReducer(AppState state, action) => AppState(
    // currentAccount: authReducer(state.currentAccount, action),
    // balance: balanceReducer(state.balance, action),
    // route: navigationReducer(state.route, action),
    // activeTab: tabsReducer(state.activeTab, action),
    );

class App extends StatelessWidget {
  final Store<AppState> store;

  const App({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _configureThemeData(),
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
      ),
    );
  }

  MaterialPageRoute _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoutes.home:
        return FabRoute(HomeScreen(), settings: settings);
      case NavigationRoutes.auth:
        return FabRoute(AuthScreen(), settings: settings);
      default:
        return MainRoute(SplashPage(), settings: settings);
    }
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      onInit: (store) {
        var completer = Completer<UserAccount>();
        completer.future.then((user) {
          if (user != null)
            store.dispatch(NavigateReplaceAction(NavigationRoutes.home));
          else
            store.dispatch(NavigateReplaceAction(NavigationRoutes.auth));
        });

        store.dispatch(CheckAccount(completer));
      },
      builder: (BuildContext context, Store store) => Scaffold(
            body: Center(
              child: SvgPicture.asset('assets/images/bitshares_logo.svg'),
            ),
          ),
    );
  }
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
  final textTheme = ThemeData.dark().textTheme;
  final iconTheme = ThemeData.dark().iconTheme;
  final theme = ThemeData.dark();
  return ThemeData.dark().copyWith(
    indicatorColor: Color(0xFF00a9e0),
    // appBarTheme: theme.appBarTheme.copyWith(color: ),
    bottomAppBarTheme: theme.bottomAppBarTheme.copyWith(color: Colors.blue),
    primaryColor: Color(0xFF3f3f3f),
    accentColor: Color(0xFF00a9e0),
    // buttonColor: Color(0xFF00a9e0),
    iconTheme: iconTheme.copyWith(color: Color(0xFF00a9e0)),
    textTheme: textTheme.copyWith(body1: textTheme.body1.copyWith()),
  );
}

class RouteAwareWidget extends StatefulWidget {
  final Widget child;

  RouteAwareWidget({this.child});

  State<RouteAwareWidget> createState() => RouteAwareWidgetState(child: child);
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  final Widget child;

  RouteAwareWidgetState({this.child});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
  }

  @override
  Widget build(BuildContext context) => Container(child: child);
}

class MainRoute<T> extends MaterialPageRoute<T> {
  MainRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => RouteAwareWidget(child: widget),
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}

class FabRoute<T> extends MaterialPageRoute<T> {
  FabRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => RouteAwareWidget(child: widget),
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }
}
