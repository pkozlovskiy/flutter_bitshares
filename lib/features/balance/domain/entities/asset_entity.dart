import 'package:flutter_wallet/database/database.dart';
import 'package:moor/moor.dart';

part 'asset_entity.g.dart';

abstract class Assets extends Table {
  TextColumn get id => text()();

  TextColumn get symbol => text()();

  IntColumn get precision => integer()();

  TextColumn get issuer => text()();
}

@UseDao(tables: [Assets])
class AssetsDao extends DatabaseAccessor<Database> with _$AssetsDaoMixin {
  AssetsDao(Database db) : super(db);

  Future<void> insertAll(List<Asset> entity) =>
      batch((batch) => batch.insertAll(
            assets,
            entity,
          ));

  Future<int> clearAll() => delete(assets).go();

  Future<List<Asset>> getAll() => select(assets).get();

  Future<List<String>> getAllIds() => select(assets).map((row) => row.id).get();
}
