import 'package:expense_tracker/view/widgets/add_button_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? typeValue;
  String? categoryValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFfafafaff),
      appBar: AppBar(
        title: const Text('Daily Expenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0XFFffffffff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: const Text('Select Type'),
              value: typeValue,
              items: ['Groceries', 'Rent']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
              onChanged: (String? value) {
                typeValue = value;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0XFFffffffff),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: const Text('Select Category'),
                items: ['Food', 'Groceries', 'Entertainment']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
                onChanged: (String? value) {
                  categoryValue = value;
                }),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0XFFffffffff),
                prefixIcon: const Icon(Icons.attach_money),
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0XFFffffffff),
                hintText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AddButtonWidget(
              btnText: 'Add',
              onTap: () {},
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}
