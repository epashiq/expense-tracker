// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
// import 'package:expense_tracker/view/pages/dash_board_page.dart';
// import 'package:expense_tracker/view/pages/edit_expense_page.dart';
// import 'package:expense_tracker/view/widgets/bottom_sheet_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class ShowExpensePage extends StatefulWidget {
//   const ShowExpensePage({super.key});

//   @override
//   State<ShowExpensePage> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<ShowExpensePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   String selectedCategory = 'All';
//   DateTimeRange? selectedDateRange;

//   List<String> categories = ['All', 'Food', 'Groceries', 'Entertainment'];

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 800));
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Future<void> _openFilterModal() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return FilterModal(
//           selectedCategory: selectedCategory,
//           categories: categories,
//           onCategorySelected: (newCategory) {
//             setState(() {
//               selectedCategory = newCategory;
//             });
//           },
//           onDateRangeSelected: (newDateRange) {
//             setState(() {
//               selectedDateRange = newDateRange;
//             });
//           },
//           onApplyFilters: () {
//             setState(() {});
//           },
//         );
//       },
//     );
//   }
//   Stream<QuerySnapshot> _getFilteredExpenses() {
//     final userUid = FirebaseAuth.instance.currentUser?.uid;
//     Query query = FirebaseFirestore.instance
//         .collection('user')
//         .doc(userUid)
//         .collection('Expense');

//     if (selectedCategory != 'All') {
//       query = query.where('category', isEqualTo: selectedCategory);
//     }

//     if (selectedDateRange != null) {
//       query = query.where('date',
//           isGreaterThanOrEqualTo: selectedDateRange!.start.toIso8601String(),
//           isLessThanOrEqualTo: selectedDateRange!.end.toIso8601String());
//     }

//     return query.snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final addExpenseProvider = Provider.of<AddExpensesProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Expenses'),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const DashboardPage()),
//               );
//             },
//             icon: const Icon(Icons.dashboard),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: _getFilteredExpenses(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'Error retrieving expenses: ${snapshot.error}',
//                   style: const TextStyle(fontSize: 18, color: Colors.red),
//                 ),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No expenses found!',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   final exp =
//                       snapshot.data!.docs[index].data() as Map<String, dynamic>;
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Type: ${exp['type'] ?? 'N/A'}',
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blueGrey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Category: ${exp['category'] ?? 'N/A'}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Amount: \$${(exp['amount'] ?? 0.0).toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Date: ${DateFormat.yMMMd().format(DateTime.parse(exp['date'])) ?? 'N/A'}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           Align(
//                             alignment: Alignment.bottomRight,
//                             child: PopupMenuButton<String>(
//                               icon: const Icon(Icons.more_vert),
//                               onSelected: (value) async {
//                                 if (value == 'update') {
//                                   addExpenseProvider.updateExpense(
//                                       snapshot.data!.docs[index].id,
//                                       exp['type'],
//                                       exp['category'],
//                                       exp['amount']);
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EditExpensePage(
//                                         expenseId:
//                                             snapshot.data!.docs[index].id,
//                                         expenseData: exp,
//                                       ),
//                                     ),
//                                   );
//                                 } else if (value == 'delete') {
//                                   bool confirm = await showDialog(
//                                         context: context,
//                                         builder: (context) => AlertDialog(
//                                           title: const Text('Confirm Deletion'),
//                                           content: const Text(
//                                               'Are you sure you want to delete this expense?'),
//                                           actions: [
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.of(context)
//                                                       .pop(true),
//                                               child: const Text('Yes'),
//                                             ),
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.of(context)
//                                                       .pop(false),
//                                               child: const Text('No'),
//                                             ),
//                                           ],
//                                         ),
//                                       ) ??
//                                       false;

//                                   if (confirm) {
//                                     addExpenseProvider.deleteExpense(
//                                         context, snapshot.data!.docs[index].id);
//                                   }
//                                 }
//                               },
//                               itemBuilder: (context) {
//                                 return [
//                                   const PopupMenuItem<String>(
//                                     value: 'update',
//                                     child: Text('Update'),
//                                   ),
//                                   const PopupMenuItem<String>(
//                                     value: 'delete',
//                                     child: Text('Delete'),
//                                   ),
//                                 ];
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _openFilterModal,
//         child: const Icon(Icons.filter_list),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
import 'package:expense_tracker/controller/provider/theme_provider.dart';
import 'package:expense_tracker/view/pages/dash_board_page.dart';
import 'package:expense_tracker/view/pages/edit_expense_page.dart';
import 'package:expense_tracker/view/widgets/bottom_sheet_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ShowExpensePage extends StatefulWidget {
  const ShowExpensePage({super.key});

  @override
  State<ShowExpensePage> createState() => _ShowExpensePageState();
}

class _ShowExpensePageState extends State<ShowExpensePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  String selectedCategory = 'All';
  DateTimeRange? selectedDateRange;

  List<String> categories = ['All', 'Food', 'Groceries', 'Entertainment'];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _openFilterModal() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FilterModal(
          selectedCategory: selectedCategory,
          categories: categories,
          onCategorySelected: (newCategory) {
            setState(() {
              selectedCategory = newCategory;
            });
          },
          onDateRangeSelected: (newDateRange) {
            setState(() {
              selectedDateRange = newDateRange;
            });
          },
          onApplyFilters: () {
            setState(() {});
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getFilteredExpenses() {
    final userUid = FirebaseAuth.instance.currentUser?.uid;
    Query query = FirebaseFirestore.instance
        .collection('user')
        .doc(userUid)
        .collection('Expense');

    if (selectedCategory != 'All') {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    if (selectedDateRange != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: selectedDateRange!.start.toIso8601String(),
          isLessThanOrEqualTo: selectedDateRange!.end.toIso8601String());
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final addExpenseProvider = Provider.of<AddExpensesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Expenses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeProvider.isDarkmode ? Colors.black : Colors.teal,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
            icon: const Icon(Icons.dashboard),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeProvider.isDarkmode
                  ? Colors.grey[850]!
                  : const Color(0xFF009688),
              themeProvider.isDarkmode ? Colors.black : const Color(0xFF004D40)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getFilteredExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error retrieving expenses: ${snapshot.error}',
                    style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkmode
                            ? Colors.redAccent
                            : Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No expenses found!',
                    style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkmode
                            ? Colors.white70
                            : Colors.black54),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final exp = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          exp['category'] == 'Food'
                              ? Icons.fastfood
                              : exp['category'] == 'Groceries'
                                  ? Icons.shopping_cart
                                  : Icons.attach_money,
                          color: Colors.teal,
                          size: 36,
                        ),
                        title: Text(
                          exp['type'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkmode
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              'Category: ${exp['category'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeProvider.isDarkmode
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${DateFormat.yMMMd().format(DateTime.parse(exp['date']))}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: themeProvider.isDarkmode
                                      ? Colors.white70
                                      : Colors.grey),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'Edit') {
                              addExpenseProvider.updateExpense(
                                  snapshot.data!.docs[index].id,
                                  exp['type'],
                                  exp['category'],
                                  exp['amount']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditExpensePage(
                                    expenseId: snapshot.data!.docs[index].id,
                                    expenseData: exp,
                                  ),
                                ),
                              );
                            } else if (value == 'Delete') {
                              bool confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete this expense?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('No'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;

                              if (confirm) {
                                addExpenseProvider.deleteExpense(
                                    context, snapshot.data!.docs[index].id);
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return ['Edit', 'Delete'].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterModal,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }
}
