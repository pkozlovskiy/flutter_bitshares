import 'package:equatable/equatable.dart';
import 'package:flutter_bitshares/dashboard/bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  DashboardEvent([List props = const []]) : super(props);
}

class LoadDashboardEvent extends DashboardEvent {
  @override
  String toString() => 'LoadDashboardEvent';
}
