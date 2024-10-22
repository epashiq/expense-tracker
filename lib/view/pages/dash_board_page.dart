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
                              backgroundColor: Colors.orange,
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: barChartData.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        barGroups: barChartData,
                        borderData: FlBorderData(
                            show: false), // Removes border around the chart
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize:
                                  40, // Allocate space for y-axis values
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '\$${value.toStringAsFixed(0)}', // Format the y-axis titles
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50, // Space for the bottom axis
                              getTitlesWidget: (double value, TitleMeta meta) {
                                String category = categoryTotals.keys
                                    .elementAt(value.toInt());
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Transform.rotate(
                                    angle:
                                        -0.45, // Rotate the titles for better fit
                                    child: Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true, // Enable grid lines
                          drawVerticalLine: false,
                          horizontalInterval: 50, // Define y-axis intervals
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey[300]!,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        barTouchData: BarTouchData(
                            enabled: true), // Enable touch interaction
                        maxY: categoryTotals.values.isNotEmpty
                            ? categoryTotals.values
                                    .reduce((a, b) => a > b ? a : b) +
                                20
                            : 100, // Adjust max y-value to scale with data
                      ),
                    )
                  : const Center(child: Text('No expenses available')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Spending Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                    8.0), // Adds padding around the ListView
                child: ListView.builder(
                  itemCount: categoryTotals.length,
                  itemBuilder: (context, index) {
                    String category = categoryTotals.keys.elementAt(index);
                    double amount = categoryTotals[category]!;

                    return Card(
                      elevation: 3, // Adds shadow to the ListTile
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0), // Space between tiles
                      child: ListTile(
                        leading: const Icon(Icons
                            .category_rounded), // Adds category-specific icon
                        title: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18, // Increased font size for category
                            fontWeight: FontWeight.bold, // Bold text for title
                          ),
                        ),
                        trailing: Text(
                          '\$${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w600, // Semi-bold for the amount
                            color: Colors
                                .green, // Color indicating a positive amount
                          ),
                        ),
                        tileColor:
                            Colors.white, // Background color for the tile
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, // Padding inside the ListTile
                          vertical: 8.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:expense_tracker/controller/provider/chart_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

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
//                   return FilterDialog();
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<ChartProvider>(
//         builder: (context, chartProvider, child) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text(
//                   'Total Expenses: \$${chartProvider.totalExpenses.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                       fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: chartProvider.barChartData.isNotEmpty
//                       ? BarChart(
//                           BarChartData(
//                             barGroups: chartProvider.barChartData,
//                             borderData: FlBorderData(show: false),
//                             titlesData: FlTitlesData(
//                               leftTitles: AxisTitles(
//                                 sideTitles: SideTitles(
//                                   showTitles: true,
//                                   reservedSize: 40,
//                                   getTitlesWidget:
//                                       (double value, TitleMeta meta) {
//                                     return Text(
//                                       '\$${value.toStringAsFixed(0)}',
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.black,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               bottomTitles: AxisTitles(
//                                 sideTitles: SideTitles(
//                                   showTitles: true,
//                                   reservedSize: 50,
//                                   getTitlesWidget:
//                                       (double value, TitleMeta meta) {
//                                     String category = chartProvider
//                                         .categoryTotals.keys
//                                         .elementAt(value.toInt());
//                                     return Padding(
//                                       padding: const EdgeInsets.only(top: 8.0),
//                                       child: Transform.rotate(
//                                         angle: -0.45,
//                                         child: Text(
//                                           category,
//                                           style: const TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                             gridData: FlGridData(
//                               show: true,
//                               drawVerticalLine: false,
//                               horizontalInterval: 50,
//                               getDrawingHorizontalLine: (value) {
//                                 return FlLine(
//                                   color: Colors.grey[300]!,
//                                   strokeWidth: 1,
//                                 );
//                               },
//                             ),
//                             barTouchData: BarTouchData(enabled: true),
//                             maxY: chartProvider.categoryTotals.values.isNotEmpty
//                                 ? chartProvider.categoryTotals.values
//                                         .reduce((a, b) => a > b ? a : b) +
//                                     20
//                                 : 100,
//                           ),
//                         )
//                       : const Center(child: Text('No expenses available')),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Spending Summary',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ListView.builder(
//                       itemCount: chartProvider.categoryTotals.length,
//                       itemBuilder: (context, index) {
//                         String category =
//                             chartProvider.categoryTotals.keys.elementAt(index);
//                         double amount = chartProvider.categoryTotals[category]!;

//                         return Card(
//                           elevation: 3,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             leading: const Icon(Icons.category_rounded),
//                             title: Text(
//                               category,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             trailing: Text(
//                               '\$${amount.toStringAsFixed(2)}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class FilterDialog extends StatelessWidget {
//   const FilterDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final chartProvider = Provider.of<ChartProvider>(context, listen: false);

//     return AlertDialog(
//       title: const Text('Filters'),
//       content: SizedBox(
//         height: 200,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButton<String>(
//               value: chartProvider.selectedCategory,
//               onChanged: (value) {
//                 if (value != null) {
//                   chartProvider.selectCategory(value);
//                 }
//               },
//               items: ['All', 'Food', 'Groceries', 'Entertainment']
//                   .map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 DateTimeRange? picked = await showDateRangePicker(
//                   context: context,
//                   initialDateRange: chartProvider.dateRange,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime.now(),
//                 );
//                 if (picked != null) {
//                   chartProvider.selectDateRange(picked);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text('Select Date Range'),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }
