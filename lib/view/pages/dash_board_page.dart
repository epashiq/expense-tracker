// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   double totalExpenses = 0.0;
//   List<PieChartSectionData> pieChartData = [];
//   Map<String, double> categoryTotals = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchExpenses();
//   }

//   Future<void> fetchExpenses() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('user')
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection('Expense')
//         .get();

//     totalExpenses = 0.0;
//     categoryTotals.clear();

//     for (var doc in querySnapshot.docs) {
//       final exp = doc.data() as Map<String, dynamic>;
//       totalExpenses += exp['amount'] ?? 0.0;

//       String category = exp['category'] ?? 'Unknown';
//       categoryTotals[category] =
//           (categoryTotals[category] ?? 0.0) + (exp['amount'] ?? 0.0);
//     }

//     pieChartData = categoryTotals.entries.map((entry) {
//       return PieChartSectionData(
//         color: _getColor(entry.key),
//         value: entry.value,
//         title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
//         radius: 30,
//       );
//     }).toList();

//     setState(() {});
//   }

//   Color _getColor(String category) {
//     switch (category) {
//       case 'Food':
//         return Colors.blue;
//       case 'Groceries':
//         return Colors.green;
//       case 'Entertainment':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expense Dashboard'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: pieChartData.isNotEmpty
//                   ? PieChart(
//                       PieChartData(
//                         sections: pieChartData,
//                         borderData: FlBorderData(show: false),
//                         sectionsSpace: 2,
//                         centerSpaceRadius: 40,
//                       ),
//                     )
//                   : const Center(child: CircularProgressIndicator()),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Spending Summary',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: categoryTotals.length,
//                 itemBuilder: (context, index) {
//                   String category = categoryTotals.keys.elementAt(index);
//                   double amount = categoryTotals[category]!;
//                   return ListTile(
//                     title: Text(category),
//                     trailing: Text('\$${amount.toStringAsFixed(2)}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalExpenses = 0.0;
  List<PieChartSectionData> pieChartData = [];
  Map<String, double> categoryTotals = {};
  String selectedCategory = 'All'; // Category filter
  DateTimeRange? dateRange; // Date range filter

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses(
      {String? category, DateTime? startDate, DateTime? endDate}) async {
    Query query = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Expense');

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    if (startDate != null && endDate != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate);
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

    pieChartData = categoryTotals.entries.map((entry) {
      return PieChartSectionData(
        color: _getColor(entry.key),
        value: entry.value,
        title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
        radius: 30,
      );
    }).toList();

    setState(() {});
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

  void _selectCategory(String? category) {
    if (category != null) {
      selectedCategory = category;
      fetchExpenses(
          category: selectedCategory,
          startDate: dateRange?.start,
          endDate: dateRange?.end);
    }
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateRange = picked;
      fetchExpenses(
          category: selectedCategory,
          startDate: dateRange?.start,
          endDate: dateRange?.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter dialog or bottom sheet here
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Filters'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: selectedCategory,
                          onChanged: _selectCategory,
                          items: ['All', 'Food', 'Groceries', 'Entertainment']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          onPressed: _selectDateRange,
                          child: const Text('Select Date Range'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: pieChartData.isNotEmpty
                  ? PieChart(
                      PieChartData(
                        sections: pieChartData,
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            const Text(
              'Spending Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: categoryTotals.length,
                itemBuilder: (context, index) {
                  String category = categoryTotals.keys.elementAt(index);
                  double amount = categoryTotals[category]!;
                  return ListTile(
                    title: Text(category),
                    trailing: Text('\$${amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
