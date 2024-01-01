// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Forecast extends _Forecast
    with RealmEntity, RealmObjectBase, RealmObject {
  Forecast(
    ObjectId id,
    String uid,
    String date,
    double total,
    double coffee,
    double food,
    double health,
    double transit,
    double grocery,
    double shopping,
    double bills,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'uid', uid);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'coffee', coffee);
    RealmObjectBase.set(this, 'food', food);
    RealmObjectBase.set(this, 'health', health);
    RealmObjectBase.set(this, 'transit', transit);
    RealmObjectBase.set(this, 'grocery', grocery);
    RealmObjectBase.set(this, 'shopping', shopping);
    RealmObjectBase.set(this, 'bills', bills);
  }

  Forecast._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get uid => RealmObjectBase.get<String>(this, 'uid') as String;
  @override
  set uid(String value) => RealmObjectBase.set(this, 'uid', value);

  @override
  String get date => RealmObjectBase.get<String>(this, 'date') as String;
  @override
  set date(String value) => RealmObjectBase.set(this, 'date', value);

  @override
  double get total => RealmObjectBase.get<double>(this, 'total') as double;
  @override
  set total(double value) => RealmObjectBase.set(this, 'total', value);

  @override
  double get coffee => RealmObjectBase.get<double>(this, 'coffee') as double;
  @override
  set coffee(double value) => RealmObjectBase.set(this, 'coffee', value);

  @override
  double get food => RealmObjectBase.get<double>(this, 'food') as double;
  @override
  set food(double value) => RealmObjectBase.set(this, 'food', value);

  @override
  double get health => RealmObjectBase.get<double>(this, 'health') as double;
  @override
  set health(double value) => RealmObjectBase.set(this, 'health', value);

  @override
  double get transit => RealmObjectBase.get<double>(this, 'transit') as double;
  @override
  set transit(double value) => RealmObjectBase.set(this, 'transit', value);

  @override
  double get grocery => RealmObjectBase.get<double>(this, 'grocery') as double;
  @override
  set grocery(double value) => RealmObjectBase.set(this, 'grocery', value);

  @override
  double get shopping =>
      RealmObjectBase.get<double>(this, 'shopping') as double;
  @override
  set shopping(double value) => RealmObjectBase.set(this, 'shopping', value);

  @override
  double get bills => RealmObjectBase.get<double>(this, 'bills') as double;
  @override
  set bills(double value) => RealmObjectBase.set(this, 'bills', value);

  @override
  Stream<RealmObjectChanges<Forecast>> get changes =>
      RealmObjectBase.getChanges<Forecast>(this);

  @override
  Forecast freeze() => RealmObjectBase.freezeObject<Forecast>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Forecast._);
    return const SchemaObject(ObjectType.realmObject, Forecast, 'Forecast', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('uid', RealmPropertyType.string),
      SchemaProperty('date', RealmPropertyType.string),
      SchemaProperty('total', RealmPropertyType.double),
      SchemaProperty('coffee', RealmPropertyType.double),
      SchemaProperty('food', RealmPropertyType.double),
      SchemaProperty('health', RealmPropertyType.double),
      SchemaProperty('transit', RealmPropertyType.double),
      SchemaProperty('grocery', RealmPropertyType.double),
      SchemaProperty('shopping', RealmPropertyType.double),
      SchemaProperty('bills', RealmPropertyType.double),
    ]);
  }
}
