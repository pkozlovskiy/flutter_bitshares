import 'package:flutter/material.dart';
import 'package:flutter_bitshares/app_state.dart';
import 'package:flutter_bitshares/navigation/navigation.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createNavigationMiddleware(
    GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, NavigateReplaceAction>(
        _navigateReplace(navigatorKey)),
    TypedMiddleware<AppState, NavigatePushAction>(_navigate(navigatorKey)),
  ];
}

_navigateReplace(GlobalKey<NavigatorState> navigatorKey) {
  return (Store<AppState> store, action, NextDispatcher next) {
    final routeName = (action as NavigateReplaceAction).routeName;
    if (store.state.route.last != routeName) {
      navigatorKey.currentState.pushReplacementNamed(routeName);
    }
    next(action); //This need to be after name checks
  };
}

_navigate(GlobalKey<NavigatorState> navigatorKey) {
  return (Store<AppState> store, action, NextDispatcher next) {
    final routeName = (action as NavigatePushAction).routeName;
    if (store.state.route.last != routeName) {
      navigatorKey.currentState.pushNamed(routeName);
    }
    next(action); //This need to be after name checks
  };
}
