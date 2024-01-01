import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:client/classes/client_transaction.dart' as t;
import 'package:flutter_test/flutter_test.dart';
import 'package:realm/realm.dart';

import 'models_test.mocks.dart';

void main() {
  test('Add transaction', () {
    final transactionDB = MockTransactionDB();
    var transactionMock =
        t.Transaction(ObjectId(), "1", "Test", "Food", 1100.0, "30/10/2023");

    when(transactionDB.getTransactions()).thenReturn([]);

    expect(transactionDB.getTransactions(), isEmpty);

    when(transactionDB.addTransaction(any, any, any, any))
        .thenReturn(transactionMock);

    var result =
        transactionDB.addTransaction("Test", "Food", 100.0, "30/10/2023");
    expect(result.amount, 1100.0);

    verify(transactionDB.addTransaction("Test", "Food", 100.0, "30/10/2023"))
        .called(1);

    when(transactionDB.getTransactions()).thenReturn([transactionMock]);

    expect(transactionDB.getTransactions(), hasLength(1));
  });

  test('Retrieve transactions', () {
    final transactionDB = MockTransactionDB();
    when(transactionDB.getTransactions()).thenReturn([
      t.Transaction(ObjectId(), "1", "Test", "Food", 1100.10, "30/10/2023"),
    ]);
    var transactions = transactionDB.getTransactions();
    verify(transactionDB.getTransactions()).called(1);

    expect(transactions, isA<List<t.Transaction>>());
    expect(transactions.length, equals(1));
    expect(transactions.first.name, equals("Test"));
    expect(transactions.first.category, equals("Food"));
    expect(transactions.first.amount, equals(1100.10));
    expect(transactions.first.date, equals("30/10/2023"));
  });

  test('Edit transaction', () {
    final transactionDB = MockTransactionDB();
    var updatedTransaction = t.Transaction(
        ObjectId(), "1", "Test123", "Coffee", 630.47, "29/10/2023");

    var originalTransaction =
        t.Transaction(ObjectId(), "1", "Test", "Food", 1100.10, "30/10/2023");

    when(transactionDB.editTransaction(any, any, any, any, any))
        .thenReturn(updatedTransaction);

    var result = transactionDB.editTransaction(
        originalTransaction, "Test123", "Coffee", 630.47, "29/10/2023");

    expect(result.name, "Test123");
    expect(result.category, "Coffee");
    expect(result.amount, 630.47);
    expect(result.date, "29/10/2023");
  });

  test('Delete transaction', () {
    final transactionDB = MockTransactionDB();

    var transactionToDelete =
        t.Transaction(ObjectId(), '1', "Test", "Food", 100.0, "30/10/2023");

    when(transactionDB.getTransactions()).thenReturn([transactionToDelete]);

    expect(transactionDB.getTransactions(), hasLength(1));

    when(transactionDB.deleteTransaction(transactionToDelete)).thenReturn(true);

    var result = transactionDB.deleteTransaction(transactionToDelete);

    verify(transactionDB.deleteTransaction(transactionToDelete)).called(1);

    expect(result, isTrue);

    when(transactionDB.getTransactions()).thenReturn([]);

    expect(transactionDB.getTransactions(), isEmpty);
  });

  test('Get Transactions By Date', () {
    final transactionDB = MockTransactionDB();
    var transactions = [
      t.Transaction(ObjectId(), "1", "Test1", "Food", 100.0, "28/10/2023"),
      t.Transaction(ObjectId(), "1", "Test2", "Coffee", 200.0, "29/10/2023"),
      t.Transaction(ObjectId(), "1", "Test3", "Health", 200.0, "30/10/2023"),
    ];

    DateTime startDate = DateTime(2023, 10, 28);
    DateTime endDate = DateTime(2023, 10, 29);

    // Set up mock to return filtered transactions based on dates
    when(transactionDB.getTransactionsByDate(startDate, endDate))
        .thenAnswer((_) {
      return transactions.where((transaction) {
        var transactionDate = DateFormat('dd/MM/yyyy').parse(transaction.date);
        return transactionDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            transactionDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    });

    var filteredTransactions =
        transactionDB.getTransactionsByDate(startDate, endDate);

    expect(filteredTransactions.length, 2);
    expect(filteredTransactions[0].name, equals("Test1"));
    expect(filteredTransactions[1].name, equals("Test2"));
  });

  test('Get Total Amount', () {
    final transactionDB = MockTransactionDB();
    var mockTransactions = [
      t.Transaction(ObjectId(), "1", "Test1", "Food", 100.0, "28/10/2023"),
      t.Transaction(ObjectId(), "1", "Test2", "Food", 110.0, "29/10/2023"),
      t.Transaction(ObjectId(), "1", "Test2", "Coffee", 200.0, "29/10/2023"),
      t.Transaction(ObjectId(), "1", "Test3", "Health", 300.0, "30/10/2023"),
      t.Transaction(ObjectId(), "1", "Test3", "Health", 100.0, "30/10/2023"),
    ];

    when(transactionDB.getTotalAmount(any, any, any)).thenAnswer((invocation) {
      int index = invocation.positionalArguments[0];
      DateTime? startDate = invocation.positionalArguments[1];
      DateTime? endDate = invocation.positionalArguments[2];

      List<t.Transaction> transactions;
      if (index == 0) {
        transactions = mockTransactions;
      } else if (index == 1) {
        transactions = mockTransactions.where((transaction) {
          var transactionDate =
              DateFormat('dd/MM/yyyy').parse(transaction.date);
          return transactionDate
                  .isAfter(startDate!.subtract(const Duration(days: 1))) &&
              transactionDate.isBefore(endDate!.add(const Duration(days: 1)));
        }).toList();
      } else {
        transactions = [];
      }

      Map<String, double> categoryTotal = {};
      transactions.forEach((transaction) {
        categoryTotal.update(
            transaction.category, (value) => value + transaction.amount,
            ifAbsent: () => transaction.amount);
      });

      return categoryTotal.entries
          .map((entry) =>
              t.Transaction(ObjectId(), "1", "", entry.key, entry.value, ""))
          .toList();
    });

    var result = transactionDB.getTotalAmount(0);
    expect(result[0].amount, 210.0);
    expect(result[1].amount, 200.0);
    expect(result[2].amount, 400.0);
  });
}
