// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_tracker/utils/snackbar_utils.dart';
// import 'package:flutter/material.dart';

// class AddExpensesProvider with ChangeNotifier {
//   TextEditingController dateController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   String? typeValue;
//   String? categoryValue;

//   Future<void> setDate(BuildContext context) async {
//     final DateTime currentDate = DateTime.now();
//     final DateTime? selectedDate = await showDatePicker(
//         context: context,
//         firstDate: DateTime(currentDate.year - 10),
//         lastDate: currentDate,
//         initialDate: currentDate);
//     if (selectedDate != null) {
//       dateController.text = formatDate(selectedDate);
//     }
//     notifyListeners();
//   }

//   String formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   }

//   Future<void> addExpense() async {
//     final db = FirebaseFirestore.instance;
//     try {
//       if (typeValue == null ||
//           categoryValue == null ||
//           amountController.text.isEmpty ||
//           dateController.text.isEmpty) {
//         SnackbarUtils.showMessage('Please fill in all required fields.');
//         return;
//       }

//       final amount = double.parse(amountController.text);
//       final date = DateTime.parse(dateController.text);
//       final String documentId = UniqueKey().toString();
//       await db.collection('Expense').doc(amountController.text).set({
//         'type': typeValue,
//         'category': categoryValue,
//         'amount': amount,
//         "date": date,
//       });

//       SnackbarUtils.showMessage('Add expense succesfully');
//     } catch (e) {
//       log(e.toString());
//       SnackbarUtils.showMessage('Add expense failed!!');
//     }
//   }
// }

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensesProvider with ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? typeValue;
  String? categoryValue;

  final DateFormat dateFormatter =
      DateFormat('dd-MM-yyyy'); // Input format for UI
  final DateFormat firestoreDateFormatter =
      DateFormat('yyyy-MM-dd'); // Format for Firestore

  Future<void> setDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(currentDate.year - 10),
      lastDate: currentDate,
      initialDate: currentDate,
    );
    if (selectedDate != null) {
      dateController.text = dateFormatter.format(selectedDate);
    }
    notifyListeners();
  }

  Future<void> addExpense() async {
    final db = FirebaseFirestore.instance;
    try {
      if (typeValue == null ||
          categoryValue == null ||
          amountController.text.isEmpty ||
          dateController.text.isEmpty) {
        SnackbarUtils.showMessage('Please fill in all required fields.');
        return;
      }

      final double amount = double.parse(amountController.text);

      // Use the date formatter to parse the date string correctly
      final DateTime date = dateFormatter.parse(dateController.text);

      // Convert the date to 'yyyy-MM-dd' format before storing it in Firestore
      final String formattedDate = firestoreDateFormatter.format(date);

      final String documentId = UniqueKey().toString();

      await db.collection('Expense').doc(documentId).set({
        'type': typeValue,
        'category': categoryValue,
        'amount': amount,
        'date': formattedDate, // Store in 'yyyy-MM-dd' format
      });

      SnackbarUtils.showMessage('Expense added successfully');
    } catch (e) {
      log(e.toString());
      SnackbarUtils.showMessage('Failed to add expense.');
    }
  }

   void clearFields() {
    dateController.clear();
    amountController.clear();
    typeValue = null;
    categoryValue = null;
    notifyListeners();  
  }
}
