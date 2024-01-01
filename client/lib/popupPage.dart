// ignore: file_names
import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'classes/bar_chart_model.dart';
import 'package:client/classes/client_transaction.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PopupPage extends StatefulWidget {
  final BarChartModel item;
  final selectedIndex;
  final DateTime startDate;
  final DateTime endDate;
  const PopupPage({
    Key? key,
    required this.item,
    required this.selectedIndex,
    required this.startDate,
    required this.endDate,
    // required this.transactions,
  }) : super(key: key);

  @override
  _PopupPageState createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  TextEditingController _targetController = TextEditingController();
  double _target = 0.0;
  late var transactions;
  var _transactions = [];
  final a = TransactionDB();

  @override
  void initState() {
    super.initState();
    try {
      if (widget.selectedIndex == 0 ||
          widget.selectedIndex == 1 ||
          widget.selectedIndex == 3) {
        transactions =
            a.getTransactionsByDate(widget.startDate, widget.endDate);
      } else {
        transactions = a.getTransactions();
      }
      _target = widget.item.actualSpending;
      _targetController.text = _target.toStringAsFixed(2);

      _transactions = transactions
          .where((transaction) => transaction.category == widget.item.category)
          .toList();
    } catch (e) {
      showErrorSnackbar(context, e.toString());
    }
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            elevation: 0,
            child: SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(widget.item.icon),
                        const SizedBox(width: 8.0),
                        Text(
                          widget.item.category,
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Total Spending: ${widget.item.actualSpending.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Transactions:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _transactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final reversedIndex =
                              _transactions.length - 1 - index;

                          return ListTile(
                            leading: Icon(
                              widget.item.icon,
                              color: charts.ColorUtil.toDartColor(
                                  widget.item.actualColor),
                            ),
                            title: Text(_transactions[reversedIndex].name),
                            subtitle: Text(
                                _transactions[reversedIndex].date as String),
                            trailing: Text(
                              _transactions[reversedIndex]
                                  .amount
                                  .toStringAsFixed(2),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      showErrorSnackbar(context, e.toString());
      return const Scaffold(
        body: Center(
          child: Text('An unexpected error occurred'),
        ),
      );
    }
  }
}
