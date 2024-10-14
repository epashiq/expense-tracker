import 'package:flutter/material.dart';

class FilterModal extends StatefulWidget {
  final String selectedCategory;
  final DateTimeRange? selectedDateRange;
  final List<String> categories;
  final Function(String) onCategorySelected;
  final Function(DateTimeRange?) onDateRangeSelected;
  final VoidCallback onApplyFilters;

  const FilterModal({
    super.key,
    required this.selectedCategory,
    this.selectedDateRange,
    required this.categories,
    required this.onCategorySelected,
    required this.onDateRangeSelected,
    required this.onApplyFilters,
  });

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late String selectedCategory;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    selectedDateRange = widget.selectedDateRange;
  }

  @override
  Widget build(BuildContext context) {
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
                items: widget.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                  widget.onCategorySelected(selectedCategory);
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
                    widget.onDateRangeSelected(picked);
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
              widget.onApplyFilters();
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
