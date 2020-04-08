import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'core/common_widgets/stream_listener_builder.dart';
import 'core/constants/navigation_routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/auth_screen.dart';
import 'features/home/home_screen.dart';

final log = Logger('Main');
final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  final List providers;

  App(this.providers);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...providers,
        Provider<GlobalKey<NavigatorState>>.value(value: navigatorKey),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _configureThemeData(),
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
        home: SplashPage(),
      ),
    );
  }
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
    textTheme: textTheme.copyWith(bodyText2: textTheme.bodyText2.copyWith()),
  );
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthBloc>(context, listen: false).add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return StreamListenableBuilder(
      stream: Provider.of<AuthBloc>(context),
      listener: (state) {
        if (state is AuthenticationUninitialized) return;
        Provider.of<GlobalKey<NavigatorState>>(context, listen: false)
            .currentState
            .pushReplacementNamed(state is AuthenticationAuthenticated
                ? NavigationRoutes.home
                : NavigationRoutes.auth);
      },
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return Scaffold(
          body: Center(
            child: SvgPicture.asset('assets/images/bitshares_logo.svg'),
          ),
        );
      },
    );
  }
}

class RouteAwareWidget extends StatefulWidget {
  final Widget child;

  RouteAwareWidget({this.child});

  State<RouteAwareWidget> createState() => RouteAwareWidgetState(child: child);
}

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
    //TODO StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
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
    if (settings.name == NavigationRoutes.splash) return child;
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
    if (settings.name == NavigationRoutes.splash) return child;
    return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }
}
