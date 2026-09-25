import 'package:flutter/material.dart';

/// Application entry point.
/// Starts the Expense Tracker app.
void main() => runApp(const ExpenseTrackerApp());

/// Represents a single expense transaction.
class Expense {
  /// Unique identifier for the expense.
  final String id;

  /// Expense description.
  final String title;

  /// Amount spent.
  final double amount;

  /// Expense category (Food, Transport, etc.).
  final String category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
  });
}

/// Root widget of the application.
class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pocket Expense',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Main screen of the expense tracker.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Stores all expense transactions.
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      title: 'Coffee & Snack',
      amount: 4.50,
      category: 'Food',
    ),
    Expense(
      id: '2',
      title: 'Bus Pass',
      amount: 12.00,
      category: 'Transport',
    ),
  ];

  /// Controller for the expense title input field.
  final _titleController = TextEditingController();

  /// Controller for the expense amount input field.
  final _amountController = TextEditingController();

  /// Default selected category.
  String _selectedCategory = 'Food';

  /// Calculates the total amount spent.
  double get _totalSpent =>
      _expenses.fold(0.0, (sum, item) => sum + item.amount);

  /// Adds a new expense to the list.
  void _addExpense() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0) return;

    setState(() {
      _expenses.add(
        Expense(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          category: _selectedCategory,
        ),
      );
    });

    _titleController.clear();
    _amountController.clear();
    Navigator.of(context).pop();
  }

  /// Displays a bottom sheet for adding a new expense.
  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Expense',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (€)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: ['Food', 'Transport', 'Bills', 'Entertainment']
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCategory = val);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addExpense,
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Budget'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.teal.shade100,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Spent:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '€${_totalSpent.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Text('No expenses added yet!'),
                  )
                : ListView.builder(
                    itemCount: _expenses.length,
                    itemBuilder: (ctx, i) {
                      final item = _expenses[i];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(item.category[0]),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(item.category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '€${item.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => setState(
                                () => _expenses.removeAt(i),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
