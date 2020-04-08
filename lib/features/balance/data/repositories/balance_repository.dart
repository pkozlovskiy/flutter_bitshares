import 'dart:async';

import 'package:flutter_wallet/core/services/rpc/websocket_service.dart';
import 'package:flutter_wallet/database/database.dart';
import 'package:flutter_wallet/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_wallet/features/balance/domain/entities/asset_entity.dart';
import 'package:flutter_wallet/features/balance/domain/entities/balance_entity.dart';
import 'package:flutter_wallet/features/balance/domain/entities/balance_with_asset.dart';
import 'package:flutter_wallet/features/balance/domain/repositories/balance_repository.dart';
import 'package:graphened/graphened.dart';
import 'package:logging/logging.dart';

final log = Logger('BalanceRepository');

class BalanceRepositoryImpl implements BalanceRepository {
  final BalanceRemoteDataSource _remoteDataSource;
  final BalanceCacheDataSource _cacheDataSource;
  final UserRepository _userRepository;

  BalanceRepositoryImpl(
    this._userRepository,
    this._cacheDataSource,
    this._remoteDataSource,
  ) {
    _userRepository.user.listen((userAccount) {
      if (userAccount != null) {
        _updateBalances(userAccount);
      } else {}
    });
  }

  @override
  Stream<List<BalanceWithAsset>> get balances => _cacheDataSource.balances;

  @override
  Future<void> updateBalances() {
    return _updateBalances(_userRepository.user.value);
  }

  Future<void> _updateBalances(UserAccount userAccount) {
    return _remoteDataSource
        .updateBalances(userAccount)
        .then((value) => _updateAssetsAndCache(value));
  }

  Future<void> _updateAssetsAndCache(List<Balance> balances) {
    return _cacheDataSource
        .getMissingAssetIds(balances.map((e) => e.asset_id).toList())
        .then((assetIds) => _remoteDataSource.updateAssets(assetIds))
        .then((assets) => _cacheDataSource.insertAssets(assets))
        .then((_) => _cacheDataSource.insertBalances(balances));
  }

  @override
  Future<void> reset() {
    return _cacheDataSource.reset();
  }
}

abstract class BalanceRemoteDataSource {
  Future<List<Asset>> updateAssets(List<String> missingAssets);

  Future<List<Balance>> updateBalances(UserAccount userAccount);
}

class BalanceRemoteDataSourceImpl implements BalanceRemoteDataSource {
  final WebsocketService _networkService;

  BalanceRemoteDataSourceImpl(this._networkService);

  @override
  Future<List<Balance>> updateBalances(UserAccount userAccount) async {
    var response =
        await _networkService.call(GetAccountBalances(userAccount, []));
    //TODO double json mapping
    return (response.result as List).map((f) => Balance.fromJson(f)).toList();
  }

  @override
  Future<List<Asset>> updateAssets(List<String> missingAssets) async {
    var response = await _networkService.call(GetAssets(missingAssets));
    //TODO double json mapping
    return (response.result as List).map((f) => Asset.fromJson(f)).toList();
  }
}

abstract class BalanceCacheDataSource {
  Stream<List<BalanceWithAsset>> get balances;

  Future<void> insertBalances(List<Balance> balances);

  Future<void> insertAssets(List<Asset> assets);

  Future<List<String>> getMissingAssetIds(List<String> assetIds);

  Future<void> reset();
}

class BalanceCacheDataSourceImpl implements BalanceCacheDataSource {
  final BalancesDao _balancesDao;
  final AssetsDao _assetsDao;

  BalanceCacheDataSourceImpl(this._balancesDao, this._assetsDao);

  @override
  Stream<List<BalanceWithAsset>> get balances => _balancesDao.balanceWithAsset;

  @override
  Future<void> insertBalances(List<Balance> balances) {
    return _balancesDao
        .clearAll()
        .then((_) => _balancesDao.insertAll(balances));
  }

  @override
  Future<void> insertAssets(List<Asset> assets) {
    return _assetsDao.insertAll(assets);
  }

  @override
  Future<List<String>> getMissingAssetIds(List<String> assetIds) {
    return _assetsDao.getAllIds().then((getAllIds) =>
        assetIds.where((element) => !getAllIds.contains(element)).toList());
  }

  @override
  Future<void> reset() {
    return Future.wait([
      _balancesDao.clearAll(),
      _assetsDao.clearAll(),
    ]);
  }
}
