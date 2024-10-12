// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
// import 'package:expense_tracker/view/pages/dash_board_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

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
//     await showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Category filter
//               Row(
//                 children: [
//                   const Text('Category:'),
//                   const SizedBox(width: 10),
//                   DropdownButton<String>(
//                     value: selectedCategory,
//                     items: categories.map((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                     onChanged: (newValue) {
//                       setState(() {
//                         selectedCategory = newValue!;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Date range picker
//               Row(
//                 children: [
//                   const Text('Date Range:'),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () async {
//                       DateTimeRange? picked = await showDateRangePicker(
//                         context: context,
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime.now(),
//                       );
//                       if (picked != null) {
//                         setState(() {
//                           selectedDateRange = picked;
//                         });
//                       }
//                     },
//                     child: const Text('Select Date Range'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Apply button
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(
//                       context); // Close the modal after applying filters
//                   setState(() {
//                     // Refresh the filtered data
//                   });
//                 },
//                 child: const Text('Apply Filters'),
//               ),
//             ],
//           ),
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

//     // Apply category filter
//     if (selectedCategory != 'All') {
//       query = query.where('category', isEqualTo: selectedCategory);
//     }

//     // Apply date range filter
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
//     final instance = FirebaseFirestore.instance
//         .collection('user')
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection('Expense')
//         .snapshots();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Expenses'),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const DashboardPage(),
//                     ));
//               },
//               icon: const Icon(Icons.dashboard))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder(
//           stream: instance,
//           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return const Center(
//                 child: Text(
//                   'Error retrieving expenses!',
//                   style: TextStyle(fontSize: 18, color: Colors.red),
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
//                   final animation =
//                       Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//                           .animate(CurvedAnimation(
//                               parent: controller, curve: Curves.easeInOut));
//                   controller.forward();
//                   return SlideTransition(
//                       position: animation,
//                       child: FadeTransition(
//                         opacity: controller,
//                         child: Card(
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Type: ${exp['type'] ?? 'N/A'}',
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.blueGrey,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Category: ${exp['category'] ?? 'N/A'}',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Amount: \$${(exp['amount'] ?? 0.0).toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Date: ${exp['date'] ?? 'N/A'}',
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: PopupMenuButton<String>(
//                                     icon: const Icon(Icons.more_vert),
//                                     onSelected: (value) {
//                                       if (value == 'update') {
//                                       } else if (value == 'delete') {
//                                         addExpenseProvider.deleteExpense(
//                                             context,
//                                             snapshot.data!.docs[index].id);
//                                       }
//                                     },
//                                     itemBuilder: (context) {
//                                       return [
//                                         const PopupMenuItem<String>(
//                                           value: 'update',
//                                           child: Text('Update'),
//                                         ),
//                                         const PopupMenuItem<String>(
//                                             value: 'delete',
//                                             child: Text('Delete')),
//                                       ];
//                                     },
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ));
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
import 'package:expense_tracker/view/pages/dash_board_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowExpensePage extends StatefulWidget {
  const ShowExpensePage({super.key});

  @override
  State<ShowExpensePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ShowExpensePage>
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
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category filter
              Row(
                children: [
                  const Text('Category:'),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date range picker
              Row(
                children: [
                  const Text('Date Range:'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDateRange = picked;
                        });
                      }
                    },
                    child: const Text('Select Date Range'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Apply button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Close the modal after applying filters
                  setState(() {
                    // Refresh the filtered data
                  });
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
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

    // Apply category filter
    if (selectedCategory != 'All') {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    // Apply date range filter
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ));
              },
              icon: const Icon(Icons.dashboard))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: _getFilteredExpenses(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error retrieving expenses!',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No expenses found!',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final exp =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final animation =
                      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: controller, curve: Curves.easeInOut));
                  controller.forward();
                  return SlideTransition(
                      position: animation,
                      child: FadeTransition(
                        opacity: controller,
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type: ${exp['type'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Category: ${exp['category'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Amount: \$${(exp['amount'] ?? 0.0).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Date: ${exp['date'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      if (value == 'update') {
                                        // Handle update action
                                      } else if (value == 'delete') {
                                        addExpenseProvider.deleteExpense(
                                            context,
                                            snapshot.data!.docs[index].id);
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem<String>(
                                          value: 'update',
                                          child: Text('Update'),
                                        ),
                                        const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Delete')),
                                      ];
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterModal,
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}
