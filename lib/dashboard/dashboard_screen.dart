import 'package:flutter/material.dart';
import 'package:flutter_bitshares/dashboard/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key key,
    @required DashboardBloc dashboardBloc,
  })  : _dashboardBloc = dashboardBloc,
        super(key: key);

  final DashboardBloc _dashboardBloc;

  @override
  DashboardScreenState createState() {
    return new DashboardScreenState(_dashboardBloc);
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  final DashboardBloc _dashboardBloc;
  DashboardScreenState(this._dashboardBloc);

  @override
  void initState() {
    super.initState();
    this._dashboardBloc.dispatch(LoadDashboardEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardEvent, DashboardState>(
        bloc: widget._dashboardBloc,
        builder: (
          BuildContext context,
          DashboardState currentState,
        ) {
          if (currentState is UnDashboardState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return new Container(
              child: new Center(
            child: new Text("DashboardScreen"),
          ));
        });
  }
}
