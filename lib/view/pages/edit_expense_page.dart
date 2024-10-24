import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/view/widgets/add_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class EditExpensePage extends StatefulWidget {
  final String expenseId; 
  final Map<String, dynamic> expenseData; 

  const EditExpensePage({
    super.key,
    required this.expenseId,
    required this.expenseData,
  });

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController typeController;
  late TextEditingController categoryController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();

    typeController = TextEditingController(text: widget.expenseData['type']);
    categoryController =
        TextEditingController(text: widget.expenseData['category']);
    amountController =
        TextEditingController(text: widget.expenseData['amount'].toString());
  }

  @override
  void dispose() {
    typeController.dispose();
    categoryController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> updateExpense() async {
    final String newType = typeController.text.trim();
    final String newCategory = categoryController.text.trim();
    final double newAmount = double.tryParse(amountController.text) ?? 0.0;

    if (newType.isEmpty || newCategory.isEmpty || newAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields properly')),
      );
      return;
    }

    final userUid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('Expense')
          .doc(widget.expenseId)
          .update({
        'type': newType,
        'category': newCategory,
        'amount': newAmount,
        'date': DateTime.now().toIso8601String(),
      });

      log('Expense updated successfully');
      Navigator.pop(context);
    } catch (error) {
      log('Failed to update expense: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update expense')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0XFFfafafaff),
      appBar: AppBar(
        title: const Text('Edit Expense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: updateExpense,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: typeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: currentTheme.colorScheme.surface,
                labelText: 'Expense Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(
                filled: true,
                fillColor: currentTheme.colorScheme.surface,
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                filled: true,
                fillColor: currentTheme.colorScheme.surface,
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AddButtonWidget(
                btnText: 'Update',
                onTap: () {
                  updateExpense();
                },
                width: MediaQuery.sizeOf(context).width)
          ],
        ),
      ),
    );
  }
}
