import 'package:flutter_wallet/database/database.dart';
import 'package:moor/moor.dart';

import 'asset_entity.dart';
import 'balance_with_asset.dart';

part 'balance_entity.g.dart';

abstract class Balances extends Table {
//  IntColumn get id => integer().nullable().autoIncrement()();

  //TODO use different obj and mapper
  TextColumn get asset_id => text()();

  IntColumn get amount => integer()();

//  @JsonKey(name: 'last_update')
  DateTimeColumn get lastUpdate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {asset_id};
}

@UseDao(tables: [Balances, Assets])
class BalancesDao extends DatabaseAccessor<Database> with _$BalancesDaoMixin {
  BalancesDao(Database db) : super(db);

  Stream<List<Balance>> get all => (select(balances)).watch();

  Stream<List<BalanceWithAsset>> get balanceWithAsset {
    final query = select(balances)
        .join([leftOuterJoin(assets, assets.id.equalsExp(balances.asset_id))]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return BalanceWithAsset(row.readTable(balances), row.readTable(assets));
      }).toList();
    });
  }

//  Future<List<String>> getMissingBalanceAssets(List<String> assetIds) =>
//      select(assets).map((row) => row.id).get();

//      (select(assets)..where((tbl) => tbl.id.isNotIn(assetIds)))
//          .map((row) => row.id)
//          .get();

//      customSelectQuery(
//        'SELECT DISTINCT id '
//        'FROM assets '
//        'WHERE asset_id NOT IN '
//        '(SELECT id FROM assets)',
//        readsFrom: {assets},
//      ).map((row) => row.readString('asset_id')).get();

  Future<void> insertAll(List<Balance> entity) =>
      batch((batch) => batch.insertAll(balances, entity));

  Future<int> clearAll() => delete(balances).go();
}
