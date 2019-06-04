import 'package:flutter_bitshares/balance/asset_entity.dart';
import 'package:flutter_bitshares/balance/balance_entity.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'db.g.dart';

@UseMoor(
  tables: [
    Balances,
    Assets,
  ],
  daos: [
    BalancesDao,
    AssetsDao,
  ],
)
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAllTables();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // we added the dueDate property in the change from version 1
          // await m.addColumn(todos, todos.dueDate);
        }
      });
}
