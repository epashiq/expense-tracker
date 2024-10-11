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

class _MyWidgetState extends State<ShowExpensePage> {
  @override
  Widget build(BuildContext context) {
    final addExpenseProvider = Provider.of<AddExpensesProvider>(context);
    final instance = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Expense')
        .snapshots();
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
          stream: instance,
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
                            'Date: ${exp['date'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'update') {
                                } else if (value == 'delete') {
                                  addExpenseProvider.deleteExpense(
                                      context, snapshot.data!.docs[index].id);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'update',
                                    child: Text('Update'),
                                  ),
                                  const PopupMenuItem<String>(
                                      value: 'delete', child: Text('Delete')),
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
    );
  }
}
