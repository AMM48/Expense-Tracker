// Mocks generated by Mockito 5.4.0 from annotations
// in client/test/goal_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:client/classes/goal.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:realm/realm.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeRealm_0 extends _i1.SmartFake implements _i2.Realm {
  _FakeRealm_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GoalDB].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoalDB extends _i1.Mock implements _i3.GoalDB {
  MockGoalDB() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Realm get realm => (super.noSuchMethod(
        Invocation.getter(#realm),
        returnValue: _FakeRealm_0(
          this,
          Invocation.getter(#realm),
        ),
      ) as _i2.Realm);
  @override
  set realm(_i2.Realm? _realm) => super.noSuchMethod(
        Invocation.setter(
          #realm,
          _realm,
        ),
        returnValueForMissingStub: null,
      );
  @override
  dynamic initG(_i2.User? user) => super.noSuchMethod(Invocation.method(
        #initG,
        [user],
      ));
  @override
  dynamic setGoal(
    double? goalAmount,
    String? goalDate,
  ) =>
      super.noSuchMethod(Invocation.method(
        #setGoal,
        [
          goalAmount,
          goalDate,
        ],
      ));
  @override
  dynamic editGoal(
    _i3.Goal? g, [
    double? progress,
    double? amount,
    String? date,
  ]) =>
      super.noSuchMethod(Invocation.method(
        #editGoal,
        [
          g,
          progress,
          amount,
          date,
        ],
      ));
  @override
  dynamic deleteGoal(_i3.Goal? g) => super.noSuchMethod(Invocation.method(
        #deleteGoal,
        [g],
      ));
}