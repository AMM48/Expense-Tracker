import 'dart:convert';

import 'package:client/classes/client_transaction.dart' as t;
import 'package:client/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:realm/realm.dart';
import 'models_test.mocks.dart';

@GenerateMocks([http.Client, t.TransactionDB])
void main() {
  group('Test Models', () {
    // Existing test for fetchCategory
    test('Testing Categorization Model', () async {
      final client = MockClient();
      when(client.post(
        Uri.parse(
            'https://clownfish-app-dv84a.ondigitalocean.app/classifyTransaction'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'message': 'test'}),
      )).thenAnswer((_) async =>
          http.Response('{"category":"Food", "probability": 67.88}', 200));

      expect(await fetchCategory("Test", client), isA<dynamic>());
    });

    // Test for fetchForecast
    test('Testing Forecast Model', () async {
      final client = MockClient();
      final transactionDB = MockTransactionDB();
      when(transactionDB.initT()).thenAnswer((_) async => 'Stub');
      when(transactionDB.getTransactions()).thenReturn([
        t.Transaction(ObjectId(), '1', "Test", "Food", 350.0, "30/7/2023"),
        t.Transaction(ObjectId(), '1', "Test", "Coffee", 150.0, "30/8/2023"),
        t.Transaction(ObjectId(), '1', "Test", "Transit", 120.0, "30/9/2023"),
        t.Transaction(ObjectId(), '1', "Test", "Health", 46.0, "30/10/2023"),
        t.Transaction(ObjectId(), '1', "Test", "Shopping", 650.0, "30/11/2023"),
        t.Transaction(ObjectId(), '1', "Test", "Bills", 1250.0, "30/12/2023"),
      ]);
      when(client.post(
        Uri.parse(
            'https://clownfish-app-dv84a.ondigitalocean.app/forecastSpendings'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response('{"Forecast": {"someKey": "someValue"}}', 200));

      final result = await fetchForecast(client, transactionDB);

      expect(result, isA<Map<String, dynamic>>());
      expect(result, contains('someKey'));
    });
  });
}
