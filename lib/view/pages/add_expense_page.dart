import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
import 'package:expense_tracker/controller/provider/auth_provider.dart';
import 'package:expense_tracker/controller/provider/theme_provider.dart';
import 'package:expense_tracker/view/pages/show_expense_page.dart';
import 'package:expense_tracker/view/widgets/add_button_widget.dart';
import 'package:expense_tracker/view/widgets/custom_date_field.dart';
import 'package:expense_tracker/view/widgets/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}
class _AddExpensePageState extends State<AddExpensePage> {
  String? typeValue;
  String? categoryValue;
  @override
  Widget build(BuildContext context) {
    final addExpenseProvider = Provider.of<AddExpensesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0XFFfafafaff),
      appBar: AppBar(
        title: const Text('Daily Expenses'),
        actions: [
          IconButton(
              onPressed: () {
                authProvider.logout(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
            icon: Icon(
                themeProvider.isDarkmode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: currentTheme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text('Select Type'),
              value: addExpenseProvider.typeValue,
              items: ['Groceries', 'Rent']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  addExpenseProvider.typeValue = value;
                  typeValue = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: currentTheme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: addExpenseProvider.categoryValue,
                hint: const Text('Select Category'),
                items: ['Food', 'Groceries', 'Entertainment']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    addExpenseProvider.categoryValue = value;
                    categoryValue = value;
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: addExpenseProvider.amountController,
                hintText: 'Amount',
                prefixIcon: Icons.attach_money),
            const SizedBox(
              height: 20,
            ),
            CustomDateField(
                controller: addExpenseProvider.dateController,
                hintText: 'Date',
                prefixIcon: Icons.calendar_month,
                onTap: () {
                  addExpenseProvider.setDate(context);
                }),
            const SizedBox(
              height: 20,
            ),
            AddButtonWidget(
              btnText: 'Add',
              onTap: () {
                addExpenseProvider.addExpense();
                addExpenseProvider.clearFields();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShowExpensePage(),
                    ));
              },
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShowExpensePage(),
            ),
          );
        },
        tooltip: 'Show expenses',
        child: const Icon(Icons.receipt_long),
      ),
    );
  }
}
