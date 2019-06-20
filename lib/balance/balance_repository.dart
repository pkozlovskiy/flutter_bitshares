import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bitshares/auth/user_repository.dart';
import 'package:flutter_bitshares/balance/balance_entity.dart';
import 'package:flutter_bitshares/db.dart';
import 'package:flutter_bitshares/services/rpc/websocket_service.dart';
import 'package:graphened/graphened.dart';
import 'package:graphened/src/api/api.dart';
import 'package:logging/logging.dart';

final log = Logger('BalanceRepository');

abstract class BalanceRepository {
  Stream<List<Balance>> get all;

  dispose(BuildContext context);
}

class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceRemoteDataSource _remoteDataSource;
  final BalanceCacheDataSource _cacheDataSource;
  final UserRepository _userRepository;

  BalanceRepositoryImpl(
    this._userRepository,
    this._cacheDataSource,
    this._remoteDataSource,
  ) {
    _remoteDataSource.subscribe(_userRepository.currentUser);
    _userRepository.onUserAccountChanged
        .where((userAccount) => userAccount.id.isNotEmpty)
        .listen((userAccount) {
      _remoteDataSource.subscribe(userAccount);
    });

    _remoteDataSource.all.listen((all) {
      _cacheDataSource.insertAll(all);
    });
  }

  @override
  Stream<List<Balance>> get all => _cacheDataSource.all;

  @override
  dispose(BuildContext context) {
//    _remoteDataSource.d
  }
}

abstract class BalanceRemoteDataSource {
  Stream<List<Balance>> get all;

  subscribe(UserAccount userAccount);
}

class BalanceRemoteDataSourceImpl implements BalanceRemoteDataSource {
  final WebsocketService _networkService;

  BalanceRemoteDataSourceImpl(this._networkService) {}

  @override
  Stream<List<Balance>> get all => _networkService.messages
      .where((response) => response?.type == GetAccountBalances)
      .map((responce) =>
          (responce.result as List).map((f) => Balance.fromJson(f)).toList());

  @override
  subscribe(UserAccount userAccount) {
    _networkService.call(GetAccountBalances(userAccount, []));
  }
}

abstract class BalanceCacheDataSource {
  Stream<List<Balance>> get all;

  insertAll(List<Balance> balances);

  Stream<List<String>> get missingAssetIds;
}

class BalanceCacheDataSourceImpl implements BalanceCacheDataSource {
  final BalancesDao _balancesDao;

  BalanceCacheDataSourceImpl(this._balancesDao);

  @override
  Stream<List<Balance>> get all => _balancesDao.all;

  @override
  insertAll(List<Balance> balances) {
    _balancesDao.db.delete(_balancesDao.db.balances).go().then((_) {
      _balancesDao.insertAll(balances);
    });
  }

  @override
  Stream<List<String>> get missingAssetIds => _balancesDao.missingAssetIds;
}
