
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensesProvider with ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? typeValue;
  String? categoryValue;

  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  final DateFormat firestoreDateFormatter = DateFormat('yyyy-MM-dd');

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

      final DateTime date = dateFormatter.parse(dateController.text);

      final String formattedDate = firestoreDateFormatter.format(date);

      final String documentId = UniqueKey().toString();

      await db.collection('Expense').doc(documentId).set({
        'type': typeValue,
        'category': categoryValue,
        'amount': amount,
        'date': formattedDate,
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

  Future<ExpenseModel> getExpense(String expenseId) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection('Expense');
    try {
      DocumentSnapshot doc = await expenseCollection.doc(expenseId).get();
      if (doc.exists) {
        var expense = ExpenseModel.fromJson(doc.data() as Map<String, dynamic>);
        amountController.text = expense.amount.toString();
        dateController.text = expense.date.toString();
        typeValue = expense.type;
        categoryValue = expense.category;
        notifyListeners();
        return expense;
      } else {
        return throw Exception('data fetching failed');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
