import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Expense').get();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Dashboard'),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';

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
//     fetchWeeklyExpenses();
//   }

//   Future<void> fetchWeeklyExpenses() async {
//     // Get the current date and the date 7 days ago
//     DateTime now = DateTime.now();
//     DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

//     // Query Firestore for expenses within the last 7 days
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('Expense')
//         .where('timestamp',
//             isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
//         .get();

//     totalExpenses = 0.0;
//     categoryTotals.clear();

//     for (var doc in querySnapshot.docs) {
//       final exp = doc.data() as Map<String, dynamic>;

//       // Ensure the 'amount' and 'timestamp' fields exist
//       double amount = exp['amount'] ?? 0.0;
//       Timestamp timestamp = exp['timestamp'] ?? Timestamp.now();

//       totalExpenses += amount;

//       String category = exp['category'] ?? 'Unknown';
//       categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;
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
//         title: const Text('Weekly Expense Dashboard'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Total Expenses (Last 7 Days): \$${totalExpenses.toStringAsFixed(2)}',
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
//               'Weekly Spending Summary',
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
