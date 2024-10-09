import 'package:flutter/material.dart';

class AddExpensesProvider with ChangeNotifier {
  TextEditingController dateController = TextEditingController();
  String? typeValue;
  String? categoryValue;
  
  Future<void> setDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(currentDate.year - 10),
        lastDate: currentDate,
        initialDate: currentDate);
    if (selectedDate != null) {
      dateController.text = formatDate(selectedDate);
    }
    notifyListeners();
  }

  String formatDate(DateTime date) {
    return '${date.day} - ${date.month} - ${date.year}';
  }
}
