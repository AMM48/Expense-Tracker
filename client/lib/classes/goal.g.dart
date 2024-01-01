// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Goal extends _Goal with RealmEntity, RealmObjectBase, RealmObject {
  Goal(
    ObjectId id,
    String uid,
    double amount,
    String date,
    double progress,
    String sDate,
    String status,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'uid', uid);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'progress', progress);
    RealmObjectBase.set(this, 'sDate', sDate);
    RealmObjectBase.set(this, 'status', status);
  }

  Goal._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get uid => RealmObjectBase.get<String>(this, 'uid') as String;
  @override
  set uid(String value) => RealmObjectBase.set(this, 'uid', value);

  @override
  double get amount => RealmObjectBase.get<double>(this, 'amount') as double;
  @override
  set amount(double value) => RealmObjectBase.set(this, 'amount', value);

  @override
  String get date => RealmObjectBase.get<String>(this, 'date') as String;
  @override
  set date(String value) => RealmObjectBase.set(this, 'date', value);

  @override
  double get progress =>
      RealmObjectBase.get<double>(this, 'progress') as double;
  @override
  set progress(double value) => RealmObjectBase.set(this, 'progress', value);

  @override
  String get sDate => RealmObjectBase.get<String>(this, 'sDate') as String;
  @override
  set sDate(String value) => RealmObjectBase.set(this, 'sDate', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  Stream<RealmObjectChanges<Goal>> get changes =>
      RealmObjectBase.getChanges<Goal>(this);

  @override
  Goal freeze() => RealmObjectBase.freezeObject<Goal>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Goal._);
    return const SchemaObject(ObjectType.realmObject, Goal, 'Goal', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('uid', RealmPropertyType.string),
      SchemaProperty('amount', RealmPropertyType.double),
      SchemaProperty('date', RealmPropertyType.string),
      SchemaProperty('progress', RealmPropertyType.double),
      SchemaProperty('sDate', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
    ]);
  }
}
