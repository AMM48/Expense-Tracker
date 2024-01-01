// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Badges extends _Badges with RealmEntity, RealmObjectBase, RealmObject {
  Badges(
    ObjectId id,
    String uid,
    String img,
    String title,
    String description,
    int requiredGoals,
    bool isUnlocked,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'uid', uid);
    RealmObjectBase.set(this, 'img', img);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'requiredGoals', requiredGoals);
    RealmObjectBase.set(this, 'isUnlocked', isUnlocked);
  }

  Badges._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get uid => RealmObjectBase.get<String>(this, 'uid') as String;
  @override
  set uid(String value) => RealmObjectBase.set(this, 'uid', value);

  @override
  String get img => RealmObjectBase.get<String>(this, 'img') as String;
  @override
  set img(String value) => RealmObjectBase.set(this, 'img', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  int get requiredGoals =>
      RealmObjectBase.get<int>(this, 'requiredGoals') as int;
  @override
  set requiredGoals(int value) =>
      RealmObjectBase.set(this, 'requiredGoals', value);

  @override
  bool get isUnlocked => RealmObjectBase.get<bool>(this, 'isUnlocked') as bool;
  @override
  set isUnlocked(bool value) => RealmObjectBase.set(this, 'isUnlocked', value);

  @override
  Stream<RealmObjectChanges<Badges>> get changes =>
      RealmObjectBase.getChanges<Badges>(this);

  @override
  Badges freeze() => RealmObjectBase.freezeObject<Badges>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Badges._);
    return const SchemaObject(ObjectType.realmObject, Badges, 'Badges', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('uid', RealmPropertyType.string),
      SchemaProperty('img', RealmPropertyType.string),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('requiredGoals', RealmPropertyType.int),
      SchemaProperty('isUnlocked', RealmPropertyType.bool),
    ]);
  }
}
