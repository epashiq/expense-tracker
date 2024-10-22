import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartProvider extends ChangeNotifier {
  double totalExpenses = 0.0;
  List<BarChartGroupData> barChartData = [];
  Map<String, double> categoryTotals = {};
  String selectedCategory = 'All';
  DateTimeRange? dateRange;

  ChartProvider() {
    fetchExpenses();
  }

  Future<void> fetchExpenses({
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query query = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Expense');

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    if (startDate != null && endDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    QuerySnapshot querySnapshot = await query.get();

    totalExpenses = 0.0;
    categoryTotals.clear();

    for (var doc in querySnapshot.docs) {
      final exp = doc.data() as Map<String, dynamic>;
      totalExpenses += exp['amount'] ?? 0.0;

      String category = exp['category'] ?? 'Unknown';
      categoryTotals[category] =
          (categoryTotals[category] ?? 0.0) + (exp['amount'] ?? 0.0);
    }

    // Build bar chart data
    barChartData = categoryTotals.entries.map((entry) {
      return BarChartGroupData(
        x: categoryTotals.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: _getColor(entry.key),
            width: 40,
            borderRadius: BorderRadius.circular(6),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    notifyListeners(); // Update UI after fetching data
  }

  Color _getColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Groceries':
        return Colors.green;
      case 'Entertainment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    fetchExpenses(
      category: selectedCategory,
      startDate: dateRange?.start,
      endDate: dateRange?.end,
    );
  }

  void selectDateRange(DateTimeRange? range) {
    if (range != null) {
      dateRange = range;
      fetchExpenses(
        category: selectedCategory,
        startDate: dateRange?.start,
        endDate: dateRange?.end,
      );
    }
  }
}
