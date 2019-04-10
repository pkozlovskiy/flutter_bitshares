import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DashboardState extends Equatable {
  DashboardState([List props = const []]) : super(props);
}

class InitialDashboardState extends DashboardState {}

class UnDashboardState extends DashboardState {}
