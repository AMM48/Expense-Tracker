import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:client/classes/client_transaction.dart';
import 'package:flutter/services.dart';

Widget buildTransactionItem(String category, double amount, IconData icon,
    Color iconColor, String date, BuildContext context) {
  // String selectedCategory = category;
  try {
    return Container(
      // margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(35.0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Icon(
              icon,
              color: iconColor,
              size: 29,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '${amount.toStringAsFixed(2)} S.R',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 76, 140, 175),
              ),
            ),
          ],
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

final transactions = TransactionDB();

void showEditTransactionDialog(
    BuildContext context, Transaction t, Function setStateCallback) {
  try {
    final TextEditingController nameController =
        TextEditingController(text: t.name);
    final TextEditingController amountController =
        TextEditingController(text: t.amount.toStringAsFixed(2));
    final TextEditingController dateController =
        TextEditingController(text: t.date);
    String selectedCategory = t.category;
    Future<void> _selectDate(
        BuildContext context, TextEditingController dateController) async {
      try {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != DateTime.now()) {
          final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
          dateController.text = formattedDate;
        }
      } catch (e) {
        showErrorSnackbar(context, e.toString());
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Transaction'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
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
                          _selectDate(context, dateController);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          try {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          } catch (e) {
                            showErrorSnackbar(context, e.toString());
                          }
                        }
                      },
                      items: [
                        'Coffee',
                        'Transit',
                        'Health',
                        'Food',
                        'Grocery',
                        'Shopping',
                        "Bills"
                      ].map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  transactions.editTransaction(
                    t,
                    nameController.text,
                    selectedCategory,
                    double.tryParse(amountController.text) ?? 0.0,
                    dateController.text,
                  );
                  setStateCallback();
                  showSuccessSnackbar(
                      context, "Transaction Edited Successfully");
                  Navigator.of(context).pop();
                } catch (e) {
                  showErrorSnackbar(context, "Failed to Edit Transaction");
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    showErrorSnackbar(context, e.toString());
  }
}

void showAddTransactionDialog(BuildContext context, Function setStateCallback) {
  try {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    String selectedCategory = "Coffee";

    final DateTime currentDate = DateTime.now();
    dateController.text =
        "${currentDate.day}/${currentDate.month}/${currentDate.year}";
    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime.now()) {
        final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
        dateController.text = formattedDate;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Transaction'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
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
                const SizedBox(height: 16.0),
                const Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }
                      },
                      items: [
                        'Coffee',
                        'Transit',
                        'Health',
                        'Food',
                        'Grocery',
                        'Shopping',
                        "Bills"
                      ].map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    );
                  },
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
                  transactions.addTransaction(
                    nameController.text,
                    selectedCategory,
                    double.tryParse(amountController.text) ?? 0.0,
                    dateController.text,
                  );

                  setStateCallback();
                  showSuccessSnackbar(
                      context, "Transaction Added Successfully");
                  Navigator.of(context).pop();
                } catch (e) {
                  showErrorSnackbar(context, "Failed to Add Transaction");
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    showErrorSnackbar(context, e.toString());
  }
}
