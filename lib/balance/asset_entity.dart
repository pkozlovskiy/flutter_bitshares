import 'package:flutter_bitshares/db.dart';
import 'package:moor/moor.dart';
part 'asset_entity.g.dart';

abstract class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get symbol => text()();
  IntColumn get precision => integer()();
  TextColumn get description => text()();
  TextColumn get issuer => text()();
  }
    //   toString(): String {
    //     if (issuer == "1.2.0")
    //         return "bit$symbol"
    //     return symbol
    // }

@UseDao(tables: [Assets])
class AssetsDao extends DatabaseAccessor<MyDatabase> with _$AssetsDaoMixin {
  AssetsDao(MyDatabase db) : super(db);

  Stream<List<Asset>> get all => (select(assets)).watch();

}
