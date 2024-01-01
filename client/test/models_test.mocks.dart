// Mocks generated by Mockito 5.4.0 from annotations
// in client/test/models_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:convert' as _i8;
import 'dart:typed_data' as _i9;

import 'package:client/classes/badges.dart' as _i6;
import 'package:client/classes/client_transaction.dart' as _i10;
import 'package:client/classes/forecast.dart' as _i5;
import 'package:client/classes/goal.dart' as _i4;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:realm/realm.dart' as _i3;

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

class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamedResponse_1 extends _i1.SmartFake
    implements _i2.StreamedResponse {
  _FakeStreamedResponse_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRealm_2 extends _i1.SmartFake implements _i3.Realm {
  _FakeRealm_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGoalDB_3 extends _i1.SmartFake implements _i4.GoalDB {
  _FakeGoalDB_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeForecastDB_4 extends _i1.SmartFake implements _i5.ForecastDB {
  _FakeForecastDB_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBadgesDB_5 extends _i1.SmartFake implements _i6.BadgesDB {
  _FakeBadgesDB_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i2.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.Response> head(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #head,
          [url],
          {#headers: headers},
        ),
        returnValue: _i7.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #head,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i7.Future<_i2.Response>);
  @override
  _i7.Future<_i2.Response> get(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [url],
          {#headers: headers},
        ),
        returnValue: _i7.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #get,
            [url],
            {#headers: headers},
          ),
        )),
      ) as _i7.Future<_i2.Response>);
  @override
  _i7.Future<_i2.Response> post(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i7.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #post,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i7.Future<_i2.Response>);
  @override
  _i7.Future<_i2.Response> put(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i7.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #put,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i7.Future<_i2.Response>);
  @override
  _i7.Future<_i2.Response> patch(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i7.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #patch,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i7.Future<_i2.Response>);
  @override
  _i7.Future<_i2.Response> delete(
    Uri? url, {
    Map<String, String>? headers,
    Object? body,
    _i8.Encoding? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {
            #headers: headers,
            #body: body,
            #encoding: encoding,
          },
        ),
        returnValue: _i7.Future<_i2.Response>.value(_FakeResponse_0(
          this,
          Invocation.method(
            #delete,
            [url],
            {
              #headers: headers,
              #body: body,
              #encoding: encoding,
            },
          ),
        )),
      ) as _i7.Future<_i2.Response>);
  @override
  _i7.Future<String> read(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [url],
          {#headers: headers},
        ),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i7.Future<_i9.Uint8List> readBytes(
    Uri? url, {
    Map<String, String>? headers,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #readBytes,
          [url],
          {#headers: headers},
        ),
        returnValue: _i7.Future<_i9.Uint8List>.value(_i9.Uint8List(0)),
      ) as _i7.Future<_i9.Uint8List>);
  @override
  _i7.Future<_i2.StreamedResponse> send(_i2.BaseRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [request],
        ),
        returnValue:
            _i7.Future<_i2.StreamedResponse>.value(_FakeStreamedResponse_1(
          this,
          Invocation.method(
            #send,
            [request],
          ),
        )),
      ) as _i7.Future<_i2.StreamedResponse>);
  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [TransactionDB].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionDB extends _i1.Mock implements _i10.TransactionDB {
  MockTransactionDB() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Realm get realm => (super.noSuchMethod(
        Invocation.getter(#realm),
        returnValue: _FakeRealm_2(
          this,
          Invocation.getter(#realm),
        ),
      ) as _i3.Realm);
  @override
  set realm(_i3.Realm? _realm) => super.noSuchMethod(
        Invocation.setter(
          #realm,
          _realm,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.GoalDB get g => (super.noSuchMethod(
        Invocation.getter(#g),
        returnValue: _FakeGoalDB_3(
          this,
          Invocation.getter(#g),
        ),
      ) as _i4.GoalDB);
  @override
  _i5.ForecastDB get f => (super.noSuchMethod(
        Invocation.getter(#f),
        returnValue: _FakeForecastDB_4(
          this,
          Invocation.getter(#f),
        ),
      ) as _i5.ForecastDB);
  @override
  _i6.BadgesDB get b => (super.noSuchMethod(
        Invocation.getter(#b),
        returnValue: _FakeBadgesDB_5(
          this,
          Invocation.getter(#b),
        ),
      ) as _i6.BadgesDB);
  @override
  dynamic getTransactionsByDate(
    DateTime? startDate,
    DateTime? endDate,
  ) =>
      super.noSuchMethod(Invocation.method(
        #getTransactionsByDate,
        [
          startDate,
          endDate,
        ],
      ));
  @override
  dynamic getTotalAmount(
    int? index, [
    DateTime? startDate,
    DateTime? endDate,
  ]) =>
      super.noSuchMethod(Invocation.method(
        #getTotalAmount,
        [
          index,
          startDate,
          endDate,
        ],
      ));
  @override
  dynamic addTransaction(
    String? name,
    String? category,
    double? amount,
    String? date,
  ) =>
      super.noSuchMethod(Invocation.method(
        #addTransaction,
        [
          name,
          category,
          amount,
          date,
        ],
      ));
  @override
  dynamic editTransaction(
    _i10.Transaction? t,
    String? name,
    String? category,
    double? amount,
    String? date,
  ) =>
      super.noSuchMethod(Invocation.method(
        #editTransaction,
        [
          t,
          name,
          category,
          amount,
          date,
        ],
      ));
  @override
  dynamic deleteTransaction(_i10.Transaction? t) =>
      super.noSuchMethod(Invocation.method(
        #deleteTransaction,
        [t],
      ));
  @override
  void addMonthlyTransactions() => super.noSuchMethod(
        Invocation.method(
          #addMonthlyTransactions,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
