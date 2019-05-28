import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:graphened/graphened.dart';

part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  String get name;
  String get password;
  @nullable
  UserAccount get currentAccount;

  @nullable
  String get error;

  factory AuthState() {
    return _$AuthState._(
      name: '',
      password: '',
    );
  }

  AuthState._();
  static Serializer<AuthState> get serializer => _$authStateSerializer;
}
