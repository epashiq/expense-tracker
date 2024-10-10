import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowExpensePage extends StatefulWidget {
  const ShowExpensePage({super.key});

  @override
  State<ShowExpensePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ShowExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Expenses'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Expense').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('No expense found!'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final exp =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return Card(
                    child: Column(
                      children: [
                        Text('Type: ${exp['type'] ?? 'N/A'}'),
                        Text('Category: ${exp['category'] ?? 'N/A'}'),
                        Text('Amount: ${exp['amount'] ?? 'N/A'}'),
                        Text('Date: ${exp['date'] ?? 'N/A'}'),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
