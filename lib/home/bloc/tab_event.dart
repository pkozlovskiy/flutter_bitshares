import 'package:equatable/equatable.dart';
import 'package:flutter_bitshares/home/bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
class TabEvent extends Equatable {
  TabEvent([List props = const []]) : super(props);
}

class UpdateTab extends TabEvent {
  final AppTab tab;

  UpdateTab(this.tab) : super([tab]);
}