import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controller/provider/add_expenses_provider.dart';
import 'package:expense_tracker/view/pages/dash_board_page.dart';
import 'package:expense_tracker/view/pages/edit_expense_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Colors.blueAccent,
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
      body: Padding(
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
                  style: const TextStyle(fontSize: 18, color: Colors.red),
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
                  return Card(
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
                            'Date: ${DateFormat.yMMMd().format(DateTime.parse(exp['date'])) ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                if (value == 'update') {
                                  addExpenseProvider.updateExpense(
                                      snapshot.data!.docs[index].id,
                                      exp['type'],
                                      exp['category'],
                                      exp['amount']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditExpensePage(
                                        expenseId:
                                            snapshot.data!.docs[index].id,
                                        expenseData: exp,
                                      ),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  bool confirm = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text(
                                              'Are you sure you want to delete this expense?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
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
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'update',
                                    child: Text('Update'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ];
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
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
