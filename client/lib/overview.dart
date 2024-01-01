import 'package:client/classes/client_transaction.dart';
import 'package:client/SpendingBarChart.dart';
import 'package:client/classes/bar_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:client/popupPage.dart';
import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'classes/client_transaction.dart';
import 'classes/forecast.dart';

class OverviewPage extends StatefulWidget {
  final Map<String, IconData> iconMap;
  final Map<String, Color> colorMap;

  const OverviewPage({Key? key, required this.iconMap, required this.colorMap})
      : super(key: key);

  @override
// ignore: library_private_types_in_public_api
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<BarChartModel>? _data;
  final f = ForecastDB();
  int _selectedIndex = 1;
  DateTime? _startDate;
  DateTime? _endDate;
  late final forecastValues;
  var forcastSpending = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var transactionss;
  final transactions = TransactionDB();

  Future<List<BarChartModel>> _loadDataFromJson(int index,
      [DateTime? startDate, DateTime? endDate]) async {
    try {
      List<Transaction> transactionList;
      if (startDate == null || endDate == null) {
        transactionList = await transactions.getTotalAmount(index);
      } else {
        transactionList =
            await transactions.getTotalAmount(index, startDate, endDate);
      }

      List<BarChartModel> barChartList = transactionList.map((transaction) {
        final colorName = transaction.category;
        final color = widget.colorMap[colorName] ?? Colors.grey;
        final lighterColor =
            Color.fromRGBO(color.red, color.green, color.blue, 0.4);
        final icon = widget.iconMap[colorName] ?? Icons.category;
        final forecastedSpending = forecastValues != null
            ? f.getPropertyValue(transaction.category, forecastValues)
            : 0.0;
        return BarChartModel(
            category: transaction.category,
            actualSpending: transaction.amount,
            forecastedSpending: forecastedSpending,
            actualColor: charts.ColorUtil.fromDartColor(color),
            forecastedColor: charts.ColorUtil.fromDartColor(lighterColor),
            icon: icon);
      }).toList();

      return barChartList;
    } catch (error) {
      showErrorSnackbar(context, error.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    initializeAsyncData();
  }

  void initializeAsyncData() async {
    try {
      forecastValues = await f.getForecast();
      _data = null;
      final today = DateTime.now();
      final thirtyDaysAgo = today.subtract(const Duration(days: 30));
      final startDate =
          DateTime(thirtyDaysAgo.year, thirtyDaysAgo.month, thirtyDaysAgo.day);
      final endDate = DateTime(today.year, today.month, today.day);
      transactionss = transactions.getTransactionsByDate(startDate, endDate);
      _selectedIndex = 1;
      loadData(1, startDate, endDate);
    } catch (error) {
      showErrorSnackbar(context, "Failed to Initialise Overview Page");
    }
  }

  void loadData(int index, [DateTime? startDate, DateTime? endDate]) async {
    try {
      var data = await _loadDataFromJson(index, startDate, endDate);
      setState(() {
        _data = data;
        final List<BarChartModel> filteredData =
            _data!.where((item) => item.actualSpending > 0).toList();
        _startDate = startDate;
        _endDate = endDate;
      });
    } catch (error) {
      setState(() {
        _data = [];
      });
      showErrorSnackbar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (_data == null) {
        return const Center(child: CircularProgressIndicator());
      } else if (_data!.isEmpty) {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Oops, it seems like you don\'t have\n any transactions in this range.',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            try {
                              final today = DateTime.now();
                              final sevenDaysAgo =
                                  today.subtract(const Duration(days: 7));
                              final startDate = DateTime(sevenDaysAgo.year,
                                  sevenDaysAgo.month, sevenDaysAgo.day);
                              final endDate =
                                  DateTime(today.year, today.month, today.day);
                              setState(() {
                                _selectedIndex = 0;
                                transactionss = transactions
                                    .getTransactionsByDate(startDate, endDate);
                                loadData(1, startDate, endDate);
                              });
                            } catch (e) {
                              showErrorSnackbar(context, e.toString());
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: _selectedIndex == 0
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(
                                    Colors.white),
                          ),
                          child: const Text(
                            'Week',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              final today = DateTime.now();
                              final monthAgo =
                                  today.subtract(const Duration(days: 30));
                              final startDate = DateTime(
                                  monthAgo.year, monthAgo.month, monthAgo.day);
                              final endDate =
                                  DateTime(today.year, today.month, today.day);
                              setState(() {
                                _selectedIndex = 1;
                                transactionss = transactions
                                    .getTransactionsByDate(startDate, endDate);
                                loadData(1, startDate, endDate);
                              });
                            } catch (e) {
                              showErrorSnackbar(context, e.toString());
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: _selectedIndex == 1
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(
                                    Colors.white),
                          ),
                          child: const Text(
                            'Month',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              setState(() {
                                _selectedIndex = 2;
                                transactionss = transactions.getTransactions();
                                loadData(0);
                              });
                            } catch (e) {
                              showErrorSnackbar(context, e.toString());
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: _selectedIndex == 2
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(
                                    Colors.white),
                          ),
                          child: const Text(
                            'All',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final pickedDateRange = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDateRange != null) {
                                setState(() {
                                  _selectedIndex = 3;
                                  transactionss =
                                      transactions.getTransactionsByDate(
                                    pickedDateRange.start,
                                    pickedDateRange.end,
                                  );
                                  loadData(1, pickedDateRange.start,
                                      pickedDateRange.end);
                                });
                              }
                            } catch (e) {
                              showErrorSnackbar(context, e.toString());
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: _selectedIndex == 3
                                ? MaterialStateProperty.all<Color>(Colors.green)
                                : MaterialStateProperty.all<Color>(
                                    Colors.white),
                          ),
                          child: const Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        final totalSpending = _data!.fold<double>(
            0, (previous, current) => previous + current.actualSpending);

        return Scaffold(
          body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        try {
                          final today = DateTime.now();
                          final sevenDaysAgo =
                              today.subtract(const Duration(days: 7));
                          final startDate = DateTime(sevenDaysAgo.year,
                              sevenDaysAgo.month, sevenDaysAgo.day);
                          final endDate =
                              DateTime(today.year, today.month, today.day);
                          setState(() {
                            _selectedIndex = 0;
                            transactionss = transactions.getTransactionsByDate(
                                startDate, endDate);
                            loadData(1, startDate, endDate);
                          });
                        } catch (e) {
                          showErrorSnackbar(context, e.toString());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: _selectedIndex == 0
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text(
                        'Week',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          final today = DateTime.now();
                          final monthAgo =
                              today.subtract(const Duration(days: 30));
                          final startDate = DateTime(
                              monthAgo.year, monthAgo.month, monthAgo.day);
                          final endDate =
                              DateTime(today.year, today.month, today.day);
                          setState(() {
                            _selectedIndex = 1;
                            transactionss = transactions.getTransactionsByDate(
                                startDate, endDate);
                            loadData(1, startDate, endDate);
                          });
                        } catch (e) {
                          showErrorSnackbar(context, e.toString());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: _selectedIndex == 1
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text(
                        'Month',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          setState(() {
                            _selectedIndex = 2;
                            transactionss = transactions.getTransactions();
                            loadData(0);
                          });
                        } catch (e) {
                          showErrorSnackbar(context, e.toString());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: _selectedIndex == 2
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text(
                        'All',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final pickedDateRange = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDateRange != null) {
                            setState(() {
                              _selectedIndex = 3;
                              transactionss =
                                  transactions.getTransactionsByDate(
                                pickedDateRange.start,
                                pickedDateRange.end,
                              );
                              loadData(1, pickedDateRange.start,
                                  pickedDateRange.end);
                            });
                          }
                        } catch (e) {
                          showErrorSnackbar(context, e.toString());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: _selectedIndex == 3
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.only(bottom: 16.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 210, 210, 210),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: SpendingBarChart(
                        data: _data!, isNotEmpty: forecastValues != null),
                  ),
                ),
                Container(
                  width: 1000,
                  padding: const EdgeInsets.only(bottom: 16.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 210, 210, 210),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Total Spendings: ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 73, 91, 105),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${totalSpending.toStringAsFixed(2)} S.R',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (forecastValues != null)
                        const SizedBox(
                          height: 10,
                        ),
                      if (forecastValues != null)
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "This Month's Forecast: ",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 90, 114, 133),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${forecastValues.total.toStringAsFixed(2)} S.R',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _data!.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 2,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final BarChartModel item = _data![index];

                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.icon,
                                  color: charts.ColorUtil.toDartColor(
                                      item.actualColor),
                                ),
                                const SizedBox(width: 8.0),
                                Container(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
// Price
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${item.actualSpending.toStringAsFixed(2)} S.R',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Visibility(
                                        visible: forecastValues != null,
                                        child: Text(
                                          '${item.forecastedSpending.toStringAsFixed(2)} S.R', // replace with your forecast value if different
                                          style: const TextStyle(
                                            fontSize: 14, // smaller font size
                                            fontWeight: FontWeight
                                                .w400, // lighter weight
                                            color:
                                                Colors.black45, // lighter shade
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    try {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: 500,
                                            child: PopupPage(
                                              item: item,
                                              selectedIndex: _selectedIndex,
                                              startDate:
                                                  _startDate ?? DateTime.now(),
                                              endDate:
                                                  _endDate ?? DateTime.now(),
                                            ),
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      showErrorSnackbar(context, e.toString());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 149, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text('View'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      // showErrorSnackbar(context, "Failed to Render Overview Page");
      print(e);
      return const Center(child: Text('An unexpected error occurred'));
    }
  }
}
