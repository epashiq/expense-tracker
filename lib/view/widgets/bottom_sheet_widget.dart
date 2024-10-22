// import 'package:flutter/material.dart';

// class FilterModal extends StatefulWidget {
//   final String selectedCategory;
//   final DateTimeRange? selectedDateRange;
//   final List<String> categories;
//   final Function(String) onCategorySelected;
//   final Function(DateTimeRange?) onDateRangeSelected;
//   final VoidCallback onApplyFilters;

//   const FilterModal({
//     super.key,
//     required this.selectedCategory,
//     this.selectedDateRange,
//     required this.categories,
//     required this.onCategorySelected,
//     required this.onDateRangeSelected,
//     required this.onApplyFilters,
//   });

//   @override
//   _FilterModalState createState() => _FilterModalState();
// }

// class _FilterModalState extends State<FilterModal> {
//   late String selectedCategory;
//   DateTimeRange? selectedDateRange;

//   @override
//   void initState() {
//     super.initState();
//     selectedCategory = widget.selectedCategory;
//     selectedDateRange = widget.selectedDateRange;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               const Text('Category:'),
//               const SizedBox(width: 10),
//               DropdownButton<String>(
//                 value: selectedCategory,
//                 items: widget.categories.map((String category) {
//                   return DropdownMenuItem<String>(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() {
//                     selectedCategory = newValue!;
//                   });
//                   widget.onCategorySelected(selectedCategory);
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               const Text('Date Range:'),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   DateTimeRange? picked = await showDateRangePicker(
//                     context: context,
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime.now(),
//                   );
//                   if (picked != null) {
//                     setState(() {
//                       selectedDateRange = picked;
//                     });
//                     widget.onDateRangeSelected(picked);
//                   }
//                 },
//                 child: const Text('Select Date Range'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               widget.onApplyFilters();
//             },
//             child: const Text('Apply Filters'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:expense_tracker/controller/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // Accessing the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkmode;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategorySelector(theme),
          const SizedBox(height: 20),
          _buildDateRangeSelector(),
          const SizedBox(height: 20),
          _buildApplyFiltersButton(),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Row(
      children: [
        Text(
          'Category:',
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor ??
                  (theme.brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey[200]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
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
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Row(
      children: [
        const Text(
          'Date Range:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            DateTimeRange? picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                final isDarkMode = themeProvider.isDarkmode;

                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: isDarkMode
                        ? const ColorScheme.dark(
                            primary: Colors.deepPurpleAccent,
                          )
                        : const ColorScheme.light(
                            primary: Colors.deepPurpleAccent,
                          ),
                    buttonTheme: const ButtonThemeData(
                      textTheme: ButtonTextTheme.primary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                selectedDateRange = picked;
              });
              widget.onDateRangeSelected(picked);
            }
          },
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
    );
  }

  Widget _buildApplyFiltersButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        widget.onApplyFilters();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        'Apply Filters',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
