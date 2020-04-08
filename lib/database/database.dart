import 'package:moor/moor.dart';

import '../features/balance/domain/entities/asset_entity.dart';
import '../features/balance/domain/entities/balance_entity.dart';

part 'database.g.dart';

//LazyDatabase _openConnection() {
//  // the LazyDatabase util lets us find the right location for the file async.
//  return LazyDatabase(() async {
//    // put the database file, called db.sqlite here, into the documents folder
//    // for your app.
//    final dbFolder = await getApplicationDocumentsDirectory();
//    final file = File(p.join(dbFolder.path, 'db.sqlite'));
//    return VmDatabase(file);
//  });
//}

@UseMoor(
  tables: [Balances, Assets],
  daos: [BalancesDao, AssetsDao],
)
class Database extends _$Database {
  Database(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {

          }
        },
      );
}
