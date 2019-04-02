import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitshares/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _homeBloc,
      child: BlocBuilder(
          bloc: _homeBloc,
          builder: (context, state) {
            return _HomePage();
          }),
    );
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeState();

  @override
  Stream<HomeState> mapEventToState(
      HomeState currentState, HomeEvent event) async* {
    switch (event) {
      case HomeEvent.wallet:
        yield HomeState();
        break;
    }
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitshares Wallet'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              authBloc.dispatch(LoggedOut());
            },
          )
        ],
      ),
    );
  }
}

class HomeState {}

enum HomeEvent { wallet }
