// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Balance extends DataClass implements Insertable<Balance> {
  final int id;
  final String asset_id;
  final int amount;
  final DateTime lastUpdate;
  Balance(
      {@required this.id,
      @required this.asset_id,
      @required this.amount,
      this.lastUpdate});
  factory Balance.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Balance(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      asset_id: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}asset_id']),
      amount: intType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      lastUpdate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_update']),
    );
  }
  factory Balance.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Balance(
      id: serializer.fromJson<int>(json['id']),
      asset_id: serializer.fromJson<String>(json['asset_id']),
      amount: serializer.fromJson<int>(json['amount']),
      lastUpdate: serializer.fromJson<DateTime>(json['lastUpdate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'asset_id': serializer.toJson<String>(asset_id),
      'amount': serializer.toJson<int>(amount),
      'lastUpdate': serializer.toJson<DateTime>(lastUpdate),
    };
  }

  @override
  BalancesCompanion createCompanion(bool nullToAbsent) {
    return BalancesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      asset_id: asset_id == null && nullToAbsent
          ? const Value.absent()
          : Value(asset_id),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      lastUpdate: lastUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdate),
    );
  }

  Balance copyWith(
          {int id, String asset_id, int amount, DateTime lastUpdate}) =>
      Balance(
        id: id ?? this.id,
        asset_id: asset_id ?? this.asset_id,
        amount: amount ?? this.amount,
        lastUpdate: lastUpdate ?? this.lastUpdate,
      );
  @override
  String toString() {
    return (StringBuffer('Balance(')
          ..write('id: $id, ')
          ..write('asset_id: $asset_id, ')
          ..write('amount: $amount, ')
          ..write('lastUpdate: $lastUpdate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(asset_id.hashCode, $mrjc(amount.hashCode, lastUpdate.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Balance &&
          other.id == this.id &&
          other.asset_id == this.asset_id &&
          other.amount == this.amount &&
          other.lastUpdate == this.lastUpdate);
}

class BalancesCompanion extends UpdateCompanion<Balance> {
  final Value<int> id;
  final Value<String> asset_id;
  final Value<int> amount;
  final Value<DateTime> lastUpdate;
  const BalancesCompanion({
    this.id = const Value.absent(),
    this.asset_id = const Value.absent(),
    this.amount = const Value.absent(),
    this.lastUpdate = const Value.absent(),
  });
  BalancesCompanion.insert({
    this.id = const Value.absent(),
    @required String asset_id,
    @required int amount,
    this.lastUpdate = const Value.absent(),
  })  : asset_id = Value(asset_id),
        amount = Value(amount);
  BalancesCompanion copyWith(
      {Value<int> id,
      Value<String> asset_id,
      Value<int> amount,
      Value<DateTime> lastUpdate}) {
    return BalancesCompanion(
      id: id ?? this.id,
      asset_id: asset_id ?? this.asset_id,
      amount: amount ?? this.amount,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

class $BalancesTable extends Balances with TableInfo<$BalancesTable, Balance> {
  final GeneratedDatabase _db;
  final String _alias;
  $BalancesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _asset_idMeta = const VerificationMeta('asset_id');
  GeneratedTextColumn _asset_id;
  @override
  GeneratedTextColumn get asset_id => _asset_id ??= _constructAssetId();
  GeneratedTextColumn _constructAssetId() {
    return GeneratedTextColumn(
      'asset_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedIntColumn _amount;
  @override
  GeneratedIntColumn get amount => _amount ??= _constructAmount();
  GeneratedIntColumn _constructAmount() {
    return GeneratedIntColumn(
      'amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastUpdateMeta = const VerificationMeta('lastUpdate');
  GeneratedDateTimeColumn _lastUpdate;
  @override
  GeneratedDateTimeColumn get lastUpdate =>
      _lastUpdate ??= _constructLastUpdate();
  GeneratedDateTimeColumn _constructLastUpdate() {
    return GeneratedDateTimeColumn(
      'last_update',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, asset_id, amount, lastUpdate];
  @override
  $BalancesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'balances';
  @override
  final String actualTableName = 'balances';
  @override
  VerificationContext validateIntegrity(BalancesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.asset_id.present) {
      context.handle(_asset_idMeta,
          asset_id.isAcceptableValue(d.asset_id.value, _asset_idMeta));
    } else if (isInserting) {
      context.missing(_asset_idMeta);
    }
    if (d.amount.present) {
      context.handle(
          _amountMeta, amount.isAcceptableValue(d.amount.value, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (d.lastUpdate.present) {
      context.handle(_lastUpdateMeta,
          lastUpdate.isAcceptableValue(d.lastUpdate.value, _lastUpdateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Balance map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Balance.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BalancesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.asset_id.present) {
      map['asset_id'] = Variable<String, StringType>(d.asset_id.value);
    }
    if (d.amount.present) {
      map['amount'] = Variable<int, IntType>(d.amount.value);
    }
    if (d.lastUpdate.present) {
      map['last_update'] = Variable<DateTime, DateTimeType>(d.lastUpdate.value);
    }
    return map;
  }

  @override
  $BalancesTable createAlias(String alias) {
    return $BalancesTable(_db, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final String symbol;
  final int precision;
  final String issuer;
  Asset(
      {@required this.id,
      @required this.symbol,
      @required this.precision,
      @required this.issuer});
  factory Asset.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return Asset(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      symbol:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}symbol']),
      precision:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}precision']),
      issuer:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}issuer']),
    );
  }
  factory Asset.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      precision: serializer.fromJson<int>(json['precision']),
      issuer: serializer.fromJson<String>(json['issuer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'symbol': serializer.toJson<String>(symbol),
      'precision': serializer.toJson<int>(precision),
      'issuer': serializer.toJson<String>(issuer),
    };
  }

  @override
  AssetsCompanion createCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      precision: precision == null && nullToAbsent
          ? const Value.absent()
          : Value(precision),
      issuer:
          issuer == null && nullToAbsent ? const Value.absent() : Value(issuer),
    );
  }

  Asset copyWith({String id, String symbol, int precision, String issuer}) =>
      Asset(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        precision: precision ?? this.precision,
        issuer: issuer ?? this.issuer,
      );
  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('precision: $precision, ')
          ..write('issuer: $issuer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(symbol.hashCode, $mrjc(precision.hashCode, issuer.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.precision == this.precision &&
          other.issuer == this.issuer);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<String> symbol;
  final Value<int> precision;
  final Value<String> issuer;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.precision = const Value.absent(),
    this.issuer = const Value.absent(),
  });
  AssetsCompanion.insert({
    @required String id,
    @required String symbol,
    @required int precision,
    @required String issuer,
  })  : id = Value(id),
        symbol = Value(symbol),
        precision = Value(precision),
        issuer = Value(issuer);
  AssetsCompanion copyWith(
      {Value<String> id,
      Value<String> symbol,
      Value<int> precision,
      Value<String> issuer}) {
    return AssetsCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      precision: precision ?? this.precision,
      issuer: issuer ?? this.issuer,
    );
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  final GeneratedDatabase _db;
  final String _alias;
  $AssetsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  GeneratedTextColumn _symbol;
  @override
  GeneratedTextColumn get symbol => _symbol ??= _constructSymbol();
  GeneratedTextColumn _constructSymbol() {
    return GeneratedTextColumn(
      'symbol',
      $tableName,
      false,
    );
  }

  final VerificationMeta _precisionMeta = const VerificationMeta('precision');
  GeneratedIntColumn _precision;
  @override
  GeneratedIntColumn get precision => _precision ??= _constructPrecision();
  GeneratedIntColumn _constructPrecision() {
    return GeneratedIntColumn(
      'precision',
      $tableName,
      false,
    );
  }

  final VerificationMeta _issuerMeta = const VerificationMeta('issuer');
  GeneratedTextColumn _issuer;
  @override
  GeneratedTextColumn get issuer => _issuer ??= _constructIssuer();
  GeneratedTextColumn _constructIssuer() {
    return GeneratedTextColumn(
      'issuer',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, symbol, precision, issuer];
  @override
  $AssetsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'assets';
  @override
  final String actualTableName = 'assets';
  @override
  VerificationContext validateIntegrity(AssetsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.symbol.present) {
      context.handle(
          _symbolMeta, symbol.isAcceptableValue(d.symbol.value, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (d.precision.present) {
      context.handle(_precisionMeta,
          precision.isAcceptableValue(d.precision.value, _precisionMeta));
    } else if (isInserting) {
      context.missing(_precisionMeta);
    }
    if (d.issuer.present) {
      context.handle(
          _issuerMeta, issuer.isAcceptableValue(d.issuer.value, _issuerMeta));
    } else if (isInserting) {
      context.missing(_issuerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Asset map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Asset.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(AssetsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.symbol.present) {
      map['symbol'] = Variable<String, StringType>(d.symbol.value);
    }
    if (d.precision.present) {
      map['precision'] = Variable<int, IntType>(d.precision.value);
    }
    if (d.issuer.present) {
      map['issuer'] = Variable<String, StringType>(d.issuer.value);
    }
    return map;
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $BalancesTable _balances;
  $BalancesTable get balances => _balances ??= $BalancesTable(this);
  $AssetsTable _assets;
  $AssetsTable get assets => _assets ??= $AssetsTable(this);
  BalancesDao _balancesDao;
  BalancesDao get balancesDao => _balancesDao ??= BalancesDao(this as Database);
  AssetsDao _assetsDao;
  AssetsDao get assetsDao => _assetsDao ??= AssetsDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [balances, assets];
}
