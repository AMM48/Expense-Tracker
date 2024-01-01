// ignore: file_names
import 'package:client/classes/badges.dart';
import 'package:client/goal_utils.dart';
import 'package:flutter/material.dart';
import 'transaction_utils.dart' as tu;
import 'package:client/classes/client_transaction.dart';
import 'package:client/classes/goal.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:client/snackbar.dart';

class HomePage extends StatefulWidget {
  final Map<String, IconData> iconMap;
  final Map<String, Color> colorMap;

  const HomePage({
    Key? key,
    required this.iconMap,
    required this.colorMap,
  }) : super(key: key);

  static const String routeName = '/Home';

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  late var transaction;
  final g = GoalDB();
  // ignore: prefer_typing_uninitialized_variables
  late var goal;
  final transactions = TransactionDB();
  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() async {
    try {
      setState(() {
        transaction = transactions.getTransactions();
        goal = g.getGoal();
        g.getSuccessGoals();
      });
    } catch (error) {
      showErrorSnackbar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget goalWidget;
    if (goal.isNotEmpty) {
      goalWidget = Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              if (goal[goal.length - 1].status == "null")
                SlidableAction(
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  onPressed: (BuildContext context) {
                    try {
                      setState(() {
                        g.deleteGoal(goal[goal.length - 1]);
                        showSuccessSnackbar(
                            context, "Goal Deleted Successfully");
                        goal = [];
                      });
                    } catch (e) {
                      showErrorSnackbar(context, "Failed to Delete Goal");
                    }
                  },
                ),
              if (goal[goal.length - 1].status == "null")
                SlidableAction(
                  backgroundColor: const Color.fromARGB(255, 255, 178, 62),
                  icon: Icons.edit,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  onPressed: (BuildContext context) {
                    try {
                      setState(() {
                        showEditGoals(
                            goal[goal.length - 1], context, _updateData);
                      });
                    } catch (e) {
                      showErrorSnackbar(context, e.toString());
                    }
                  },
                ),
              if (goal[goal.length - 1].status == "Success" ||
                  goal[goal.length - 1].status == "Failure")
                SlidableAction(
                  backgroundColor: Colors.green,
                  icon: Icons.add,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  onPressed: (BuildContext context) {
                    try {
                      setState(() {
                        showSetGoal(context, _updateData);
                      });
                    } catch (e) {
                      showErrorSnackbar(context, e.toString());
                    }
                  },
                ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: goal[goal.length - 1].progress / 100,
                    strokeWidth: 15.0,
                    backgroundColor: Colors.green,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (goal[goal.length - 1].status ==
                        "null") // Check if status is null
                      const Text(
                        'Goal',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    if (goal[goal.length - 1].status ==
                        "null") // Check if status is null
                      const SizedBox(height: 8.0),
                    if (goal[goal.length - 1].status ==
                        "null") // Check if status is null
                      Text(
                        '${goal[goal.length - 1].amount} S.R',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (goal[goal.length - 1].status ==
                        "null") // Check if status is null
                      const SizedBox(height: 8.0),
                    if (goal[goal.length - 1].status == "null")
                      Text(
                        '${goal[goal.length - 1].date}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    if (goal[goal.length - 1].status == "Success")
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 48.0,
                        color: Colors.green,
                      ),
                    if (goal[goal.length - 1].status == "Success")
                      const Text(
                        'Goal Achieved',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    if (goal[goal.length - 1].status == "Success")
                      ElevatedButton(
                        onPressed: () {
                          try {
                            showSetGoal(context, _updateData);
                          } catch (e) {
                            showErrorSnackbar(context, e.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('New Goal'),
                      ),
                    if (goal[goal.length - 1].status == "Failure")
                      const Icon(
                        Icons.close_rounded,
                        size: 48.0,
                        color: Colors.red,
                      ),
                    if (goal[goal.length - 1].status == "Failure")
                      const Text(
                        'Goal Failed',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    if (goal[goal.length - 1].status == "Failure")
                      ElevatedButton(
                        onPressed: () {
                          try {
                            showSetGoal(context, _updateData);
                          } catch (e) {
                            showErrorSnackbar(context, e.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('New Goal'),
                      )
                  ],
                )
              ],
            ),
          ));
    } else {
      goalWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 40.0, color: Colors.grey),
          const Text(
            'No Goal Set',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 115, 115, 115)),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              try {
                showSetGoal(context, _updateData);
              } catch (e) {
                showErrorSnackbar(context, e.toString());
              }
            },
            child: const Text('Set a Goal'),
          ),
          const SizedBox(height: 8.0),
        ],
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            // color: Colors.white,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: goalWidget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      tu.showAddTransactionDialog(context, _updateData);
                    } catch (error) {
                      showErrorSnackbar(context, error.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0, left: 11, right: 11),
            child: Divider(
              height: 2,
              thickness: 1.2,
              color: Color.fromARGB(255, 205, 205, 205),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                try {
                  _updateData();
                } catch (error) {
                  showErrorSnackbar(context, error.toString());
                }
              },
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: transaction.isEmpty ? 1 : transaction.length,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (transaction.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.info_outline,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'You have no transactions.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final transactionItem = transaction[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  onPressed: (BuildContext context) {
                                    try {
                                      setState(() {
                                        transactions
                                            .deleteTransaction(transactionItem);
                                        showSuccessSnackbar(context,
                                            "Transaction Deleted Successfully");
                                      });
                                    } catch (e) {
                                      showErrorSnackbar(context,
                                          "Failed to Delete Transaction");
                                    }
                                  },
                                ),
                                SlidableAction(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 178, 62),
                                  icon: Icons.edit,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  onPressed: (BuildContext context) {
                                    try {
                                      setState(() {
                                        tu.showEditTransactionDialog(
                                          context,
                                          transactionItem,
                                          _updateData,
                                        );
                                      });
                                    } catch (e) {
                                      showErrorSnackbar(context, e.toString());
                                    }
                                  },
                                ),
                              ],
                            ),
                            child: tu.buildTransactionItem(
                              transactionItem.name,
                              transactionItem.amount,
                              widget.iconMap[transactionItem.category] ??
                                  Icons.category,
                              widget.colorMap[transactionItem.category] ??
                                  Colors.grey,
                              transactionItem.date,
                              context,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
