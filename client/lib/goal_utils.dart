import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'classes/goal.dart';

final goal = GoalDB();

showSetGoal(BuildContext context, Function setStateCallback) {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime currentDate = DateTime.now();
  currentDate = currentDate.add(const Duration(days: 1));
  dateController.text =
      "${currentDate.day}/${currentDate.month}/${currentDate.year}";

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: currentDate.add(const Duration(days: 365)),
      );
      if (picked != null && picked != DateTime.now()) {
        final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
        dateController.text = formattedDate;
      }
    } catch (error) {
      showErrorSnackbar(context, error.toString());
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Set Goal'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(\.\d{0,2})?$'))
                ],
              ),
              Row(
                children: [
                  const Text('Date: '),
                  Expanded(
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              try {
                double goalAmount =
                    double.tryParse(amountController.text) ?? 0.0;
                if (goalAmount >= 10) {
                  String goalDate = dateController.text;
                  goal.setGoal(goalAmount, goalDate);
                  setStateCallback();
                  showSuccessSnackbar(context, "Goal Set Successfully");
                } else {
                  showErrorSnackbar(context, "Amount should be at least 10");
                }
                Navigator.of(context).pop();
              } catch (error) {
                showErrorSnackbar(context, "Failed to Set Goal");
              }
            },
            child: const Text('Set Goal'),
          ),
        ],
      );
    },
  );
}

showEditGoals(Goal g, BuildContext context, Function setStateCallback) {
  final TextEditingController amountController =
      TextEditingController(text: g.amount.toStringAsFixed(2));
  final TextEditingController dateController =
      TextEditingController(text: g.date);
  DateTime currentDate = DateTime.now();
  currentDate = currentDate.add(const Duration(days: 1));
  dateController.text =
      "${currentDate.day}/${currentDate.month}/${currentDate.year}";

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: currentDate.add(const Duration(days: 365)),
      );
      if (picked != null && picked != DateTime.now()) {
        final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
        dateController.text = formattedDate;
      }
    } catch (error) {
      showErrorSnackbar(context, error.toString());
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Goal'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(\.\d{0,2})?$'))
                ],
              ),
              Row(
                children: [
                  const Text('Date: '),
                  Expanded(
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              try {
                double goalAmount =
                    double.tryParse(amountController.text) ?? 0.0;
                String goalDate = dateController.text;
                if (goalAmount == g.amount) {
                  goal.editGoal(g, g.progress, goalAmount, goalDate);
                  showSuccessSnackbar(context, "Goal Edited Successfully");
                } else if (goalAmount >= 10) {
                  var amountSpent = (g.progress / 100) * g.amount;
                  var newProgress = (amountSpent / goalAmount) * 100;
                  goal.editGoal(g, newProgress, goalAmount, goalDate);
                  showSuccessSnackbar(context, "Goal Edited Successfully");
                } else {
                  showErrorSnackbar(context, "Amount should be at least 10");
                }
                setStateCallback();
                Navigator.of(context).pop();
              } catch (error) {
                showErrorSnackbar(context, "Failed to Edit Goal");
              }
            },
            child: const Text('Edit Goal'),
          ),
        ],
      );
    },
  );
}
