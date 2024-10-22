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
//   String selectedCategory = 'All';
//   DateTimeRange? dateRange;

//   @override
//   void initState() {
//     super.initState();
//     fetchExpenses();
//   }

//   Future<void> fetchExpenses({
//     String? category,
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     Query query = FirebaseFirestore.instance
//         .collection('user')
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection('Expense');

//     if (category != null && category != 'All') {
//       query = query.where('category', isEqualTo: category);
//     }
//     if (startDate != null && endDate != null) {
//       query = query.where(
//         'date',
//         isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
//         isLessThanOrEqualTo: Timestamp.fromDate(endDate),
//       );
//     }

//     QuerySnapshot querySnapshot = await query.get();

//     totalExpenses = 0.0;
//     categoryTotals.clear();

//     for (var doc in querySnapshot.docs) {
//       final exp = doc.data() as Map<String, dynamic>;
//       totalExpenses += exp['amount'] ?? 0.0;

//       String category = exp['category'] ?? 'Unknown';
//       categoryTotals[category] =
//           (categoryTotals[category] ?? 0.0) + (exp['amount'] ?? 0.0);
//     }

//     // Build pie chart data
//     pieChartData = categoryTotals.entries.map((entry) {
//       return PieChartSectionData(
//         color: _getColor(entry.key),
//         value: entry.value,
//         title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
//         radius: 80,
//         titleStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//         titlePositionPercentageOffset: 0.6,
//         showTitle: true,
//         borderSide: BorderSide(
//           color: Colors.black12,
//           width: 2,
//         ),
//         badgeWidget: const Icon(
//           Icons.star,
//           color: Colors.yellow,
//           size: 20,
//         ),
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

//   void _selectCategory(String? category) {
//     if (category != null) {
//       selectedCategory = category;
//       fetchExpenses(
//         category: selectedCategory,
//         startDate: dateRange?.start,
//         endDate: dateRange?.end,
//       );
//     }
//   }

//   void _selectDateRange() async {
//     DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: dateRange,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         dateRange = picked; // Store the selected date range
//         print(
//             'Selected date range: ${dateRange?.start} to ${dateRange?.end}'); // Debug statement
//       });

//       // Fetch expenses with the new date range
//       await fetchExpenses(
//         category: selectedCategory,
//         startDate: dateRange?.start,
//         endDate: dateRange?.end,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expense Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: const Text('Filters'),
//                     content: SizedBox(
//                       height: 200,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           DropdownButton<String>(
//                             value: selectedCategory,
//                             onChanged: _selectCategory,
//                             items: ['All', 'Food', 'Groceries', 'Entertainment']
//                                 .map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: _selectDateRange,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             child: const Text(
//                               'Select Date Range',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: const Text('Close'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
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
//                   : const Center(child: Text('No expenses available')),
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
import 'package:expense_tracker/controller/provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalExpenses = 0.0;
  List<BarChartGroupData> barChartData = [];
  Map<String, double> categoryTotals = {};
  String selectedCategory = 'All';
  DateTimeRange? dateRange;

  @override
  void initState() {
    super.initState();
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
        endDate: dateRange?.end,
      );
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
      setState(() {
        dateRange = picked;
      });

      await fetchExpenses(
        category: selectedCategory,
        startDate: dateRange?.start,
        endDate: dateRange?.end,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkmode;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Filters'),
                    content: SizedBox(
                      height: 200,
                      child: Column(
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
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _selectDateRange,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Select Date Range',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: barChartData.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        barGroups: barChartData,
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '\$${value.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                String category = categoryTotals.keys
                                    .elementAt(value.toInt());
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Transform.rotate(
                                    angle: -0.45,
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 50,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: isDarkMode
                                  ? Colors.grey[800]!
                                  : Colors.grey[300]!,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        barTouchData: BarTouchData(enabled: true),
                        maxY: categoryTotals.values.isNotEmpty
                            ? categoryTotals.values
                                    .reduce((a, b) => a > b ? a : b) +
                                20
                            : 100,
                      ),
                    )
                  : const Center(child: Text('No expenses available')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Spending Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: categoryTotals.length,
                  itemBuilder: (context, index) {
                    String category = categoryTotals.keys.elementAt(index);
                    double amount = categoryTotals[category]!;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white, // Adapt to dark mode
                      child: ListTile(
                        leading: Icon(
                          Icons.category_rounded,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          category,
                        ),
                        trailing: Text(
                          '\$${amount.toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
