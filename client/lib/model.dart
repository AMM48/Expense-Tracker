import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'classes/client_transaction.dart';

Future<dynamic> fetchCategory(String message, http.Client client) async {
  const String apiUrl =
      '<API-URL>';

  final Map<String, String> requestBody = {
    'message': message.toLowerCase(),
  };

  try {
    final http.Response response = await client.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      print('Error message: ${response.body}');
      return {"category": "Shopping", "probability": 0.0};
    }
  } catch (error) {
    print('Error: $error');
    return {"category": "Shopping", "probability": 0.0};
  }
}

Future<dynamic> fetchForecast(http.Client client, TransactionDB d) async {
  final transactions = TransactionDB();
  var transactionsList = d.getTransactions();
  var format = DateFormat('yyyy-MM');
  Set<String> uniqueMonths = {};
  for (Transaction transaction in transactionsList) {
    DateTime date = DateFormat('dd/MM/yyyy').parse(transaction.date);
    String monthYear = format.format(date);
    uniqueMonths.add(monthYear);
  }
  if (uniqueMonths.length >= 3) {
    List<Map<String, dynamic>> transactionsJsonList = [];

    for (Transaction transaction in transactionsList) {
      transactionsJsonList.add(transactionToJson(transaction));
    }

    String jsonString = jsonEncode({"spendings": transactionsJsonList});
    var url = Uri.parse(
        '<API-URL>');
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await client.post(url, headers: headers, body: jsonString);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Data sent successfully!");
        if (responseBody['Forecast'] == null) return {};
        return responseBody['Forecast'];
      } else {
        print("Error sending data: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      return {};
    }
  } else {
    return {};
  }
}

Map<String, dynamic> transactionToJson(Transaction transaction) {
  return {
    'category': transaction.category,
    'amount': transaction.amount,
    'date': transaction.date,
  };
}
