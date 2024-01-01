import 'dart:io';
import 'dart:math';

import 'package:client/classes/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:client/classes/auth.dart';
import 'package:client/classes/goal.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import 'forecast.dart';

part 'client_transaction.g.dart';

@RealmModel()
class _Transaction {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late String uid;
  late String name;
  late String category;
  late double amount;
  late String date;
}

class TransactionDB {
  static final TransactionDB _singleton = TransactionDB._internal();
  late Realm realm;
  final g = GoalDB();
  final f = ForecastDB();
  final b = BadgesDB();
  factory TransactionDB() {
    return _singleton;
  }

  TransactionDB._internal();

  initT() async {
    final app = App(AppConfiguration(<APP-ID>));
    final token = await Auth().currentUser?.getIdToken();
    final jwtCredentials = Credentials.jwt(token!);
    final user = await app.logIn(jwtCredentials);
    realm = Realm(Configuration.flexibleSync(user, [Transaction.schema]));
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions
          .add(realm.query<Transaction>("uid == '${Auth().currentUser!.uid}'"));
    });
    await realm.subscriptions.waitForSynchronization();
    await g.initG(user);
    await f.initF(user);
    await b.initB(user);
  }

  getTransactions() {
    var transactions =
        realm.query<Transaction>("uid == '${Auth().currentUser!.uid}'");
    return transactions;
  }

  getTransactionsByDate(DateTime startDate, DateTime endDate) {
    var transactions = realm
        .query<Transaction>("uid == '${Auth().currentUser!.uid}'")
        .where((transaction) {
      var dateParts = transaction.date.split('/');
      var transactionDate = DateTime(int.parse(dateParts[2]),
          int.parse(dateParts[1]), int.parse(dateParts[0]));
      return transactionDate.isAfter(startDate) &&
              transactionDate.isBefore(endDate) ||
          transactionDate.isAtSameMomentAs(startDate) ||
          transactionDate.isAtSameMomentAs(endDate);
    }).toList();

    return transactions;
  }

  getTotalAmount(int index, [DateTime? startDate, DateTime? endDate]) {
    var transactions;
    Map<String, double> categoryTotal = {
      "Food": 0,
      "Coffee": 0,
      "Transit": 0,
      "Health": 0,
      "Grocery": 0,
      "Shopping": 0,
      "Bills": 0
    };
    if (index == 0) {
      transactions = getTransactions();
    } else if (index == 1) {
      transactions = getTransactionsByDate(startDate!, endDate!);
    }

    for (Transaction transaction in transactions) {
      double? currentAmount = categoryTotal[transaction.category];
      if (currentAmount != null) {
        categoryTotal[transaction.category] =
            currentAmount + transaction.amount;
      }
    }

    List<Transaction> totalAmount = [];
    categoryTotal.forEach((category, amount) {
      // if (amount != 0) {
      totalAmount.add(Transaction(
          ObjectId(), Auth().currentUser!.uid, "", category, amount, ""));
      // }
    });
    return totalAmount;
  }

  addTransaction(
    String name,
    String category,
    double amount,
    String date,
  ) {
    var t = Transaction(ObjectId(), Auth().currentUser!.uid, name.toUpperCase(),
        category, amount, date);
    realm.write(() {
      realm.add(t);
    });
    var goal = g.getGoal();
    DateFormat format = DateFormat("dd/M/yyyy");
    DateTime d = format.parse(date);
    var sDate;
    if (goal.isNotEmpty) {
      sDate = format.parse(goal[goal.length - 1].sDate);

      if (goal.isNotEmpty && d.isAfter(sDate) || d.isAtSameMomentAs(sDate)) {
        var progress;
        if (goal[goal.length - 1].progress == 0.0) {
          progress = (amount / goal[goal.length - 1].amount) * 100;
        } else {
          var totalAmountPaid = (goal[goal.length - 1].progress / 100) *
              goal[goal.length - 1].amount;
          totalAmountPaid += amount;
          progress = (totalAmountPaid / goal[goal.length - 1].amount) * 100;
        }
        g.editGoal(goal[goal.length - 1], progress);
      }
    }
  }

  editTransaction(
      Transaction t, String name, String category, double amount, String date) {
    var goal = g.getGoal();
    var a = t.amount;
    realm.write(() {
      t.name = name;
      t.category = category;
      t.amount = amount;
      t.date = date;
    });

    DateFormat format = DateFormat("dd/M/yyyy");
    DateTime d = format.parse(t.date);
    var sDate;
    if (goal.isNotEmpty) {
      sDate = format.parse(goal[goal.length - 1].sDate);
      if (goal.isNotEmpty && d.isAfter(sDate) || d.isAtSameMomentAs(sDate)) {
        var totalAmountPaid = (goal[goal.length - 1].progress / 100) *
            goal[goal.length - 1].amount;
        if (amount != a) {
          totalAmountPaid -= a; // Subtract the old amount
          totalAmountPaid += amount; // Add the new amount
          var progress = (totalAmountPaid / goal[goal.length - 1].amount) * 100;
          if (progress < 0.0) progress = 0.0;
          g.editGoal(goal[goal.length - 1], progress);
        } else {
          return;
        }
        var progress = (totalAmountPaid / goal[goal.length - 1].amount) * 100;
        if (progress < 0.0) progress = 0.0;

        g.editGoal(goal[goal.length - 1], progress);
      }
    }
  }

  deleteTransaction(Transaction t) {
    var goal = g.getGoal();
    var a = t.amount;
    var date = t.date;
    realm.write(() {
      realm.delete(t);
    });
    DateFormat format = DateFormat("dd/M/yyyy");
    DateTime d = format.parse(date);
    var sDate;
    if (goal.isNotEmpty) {
      sDate = format.parse(goal[goal.length - 1].sDate);
      if (goal.isNotEmpty && d.isAfter(sDate) || d.isAtSameMomentAs(sDate)) {
        var totalAmountPaid = (goal[goal.length - 1].progress / 100) *
            goal[goal.length - 1].amount;
        totalAmountPaid -= a;
        var progress = (totalAmountPaid / goal[goal.length - 1].amount) * 100;
        if (progress < 0.0) progress = 0.0;
        g.editGoal(goal[goal.length - 1], progress);
      }
    }
  }

  void addMonthlyTransactions() {
    var random = Random();

    Map<String, List<int>> categories = {
      'Food': [250, 700],
      'Coffee': [200, 550],
      'Health': [50, 180],
      'Grocery': [500, 1200],
      'Shopping': [500, 2000],
      'Transit': [240, 500],
      'Bills': [540, 850],
    };

    var startDate = DateTime(2023, 3, 1);
    var endDate = DateTime(2023, 10, 30);

    for (var month = startDate.month; month <= endDate.month; month++) {
      for (var category in categories.entries) {
        double monthlyTotal = 0.0;
        while (monthlyTotal < category.value[0]) {
          var date = DateTime(2023, month, random.nextInt(30) + 1);
          var amount =
              random.nextDouble() * (category.value[1] - category.value[0]) +
                  category.value[0];
          monthlyTotal += amount;
          if (monthlyTotal > category.value[1]) {
            amount -= monthlyTotal - category.value[1];
            monthlyTotal = category.value[1] as double;
          }
          var transaction = Transaction(
            ObjectId(),
            Auth().currentUser!.uid,
            category.key.toUpperCase(),
            category.key,
            amount,
            "${date.day}/${date.month}/${date.year}",
          );
          realm.write(() => realm.add(transaction));
        }
      }
    }
  }

  deleteAll() {
    var transactions = getTransactions();
    for (Transaction t in transactions) {
      realm.write(() {
        realm.delete(t);
      });
    }
  }

  exportTransactions() async {
    List<List<dynamic>> rows = [];
    var transactions = getTransactions();
    if (transactions.isEmpty) {
      return "null";
    }

    rows.add(["Date", "Name", "Amount", "Category"]);

    // Add data rows
    for (Transaction transaction in transactions) {
      List<dynamic> row = [];
      row.add(transaction.date);
      row.add(transaction.name);
      row.add(transaction.amount);
      row.add(transaction.category);
      rows.add(row);
    }
    String formattedDate = DateFormat('yyyy_MM_dd').format(DateTime.now());

    final fileName = 'my_transactions_$formattedDate.csv';
    String csv = const ListToCsvConverter().convert(rows);

    File file = File('/storage/emulated/0/Download/$fileName');
    await file.writeAsString(csv);
  }
}
