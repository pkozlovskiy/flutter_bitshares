import 'package:flutter_bitshares/auth/auth.dart';
import 'package:flutter_bitshares/balance/balance_repository.dart';

class RepositoryFacade {
  final UserRepository userRepository;
  final BalanceRepository balanceRepository;

  RepositoryFacade(
    this.userRepository,
    this.balanceRepository,
  );
}
