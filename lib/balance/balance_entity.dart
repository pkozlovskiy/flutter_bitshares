import 'package:flutter_bitshares/balance/asset_entity.dart';
import 'package:flutter_bitshares/balance/balance_repository.dart';
import 'package:flutter_bitshares/db.dart';
import 'package:moor/moor.dart';
part 'balance_entity.g.dart';

abstract class Balances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get assetId => text()();
  IntColumn get assetAmount => integer()();
  IntColumn get lastUpdate => integer()();
}

@UseDao(tables: [Balances, Assets])
class BalancesDao extends DatabaseAccessor<MyDatabase>
    with _$BalancesDaoMixin
    implements BalanceRepository {
  BalancesDao(MyDatabase db) : super(db);

  Stream<List<Balance>> get all => (select(balances)).watch();

  Future<int> insert(Balance entity) => into(balances).insert(entity);

  insertAll(List<Balance> entity) =>
      into(balances).insertAll(entity, orReplace: true);

  Stream<List<String>> get missingAssetIds =>  
    customSelectStream(
      'SELECT DISTINCT asset_id FROM balances WHERE asset_id NOT IN (SELECT id FROM assets)',
      readsFrom: {
        balances,
        assets
      }, // used for the stream: the stream will update when either table changes
    ).map((rows) {
      return rows.map((row) => row.readString('asset_id'));
    });
  
}
