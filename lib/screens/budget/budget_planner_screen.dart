import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../models/trip.dart';

class BudgetPlannerScreen extends StatefulWidget {
  final Trip? trip;

  const BudgetPlannerScreen({super.key, this.trip});

  @override
  State<BudgetPlannerScreen> createState() => _BudgetPlannerScreenState();
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  final _budgetController = TextEditingController();
  double? _totalBudget;
  
  // Mock expenses data
  final Map<String, double> _categoryExpenses = {
    'Accommodation': 1500,
    'Food': 700,
    'Transport': 400,
    'Activities': 1200,
    'Shopping': 800,
    'Emergency': 400,
  };

  double get _totalExpenses {
    return _categoryExpenses.values.fold(0, (sum, value) => sum + value);
  }

  double? get _remainingBudget {
    return _totalBudget != null ? _totalBudget! - _totalExpenses : null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.trip?.budget != null) {
      _totalBudget = widget.trip!.budget;
      _budgetController.text = _totalBudget!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _setBudget() {
    final budget = double.tryParse(_budgetController.text);
    if (budget != null && budget > 0) {
      setState(() {
        _totalBudget = budget;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget set successfully!')),
      );
    }
  }

  void _addExpense(String category) {
    showDialog(
      context: context,
      builder: (context) {
        final amountController = TextEditingController();
        return AlertDialog(
          title: Text('Add Expense - $category'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  setState(() {
                    _categoryExpenses[category] =
                        (_categoryExpenses[category] ?? 0) + amount;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Planner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Input Card
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Set Your Trip Budget',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Total Budget',
                              prefixIcon: Icon(Icons.account_balance_wallet),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _setBudget,
                          child: const Text('Set'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Budget Summary
            if (_totalBudget != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Budget',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_totalBudget!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _totalExpenses / _totalBudget!,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _remainingBudget! > 0
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Spent',
                                style: TextStyle(color: AppTheme.textSecondary),
                              ),
                              Text(
                                '\$${_totalExpenses.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Remaining',
                                style: TextStyle(
                                  color: _remainingBudget! > 0
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                ),
                              ),
                              Text(
                                '\$${_remainingBudget!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _remainingBudget! > 0
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_remainingBudget! < 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: AppTheme.errorColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'You have exceeded your budget!',
                                    style: TextStyle(color: AppTheme.errorColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Category Breakdown
            Text(
              'Budget Breakdown by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...AppConstants.expenseCategories.map((category) {
              final expense = _categoryExpenses[category] ?? 0;
              final percentage = _totalBudget != null && _totalBudget! > 0
                  ? (expense / _totalBudget!) * 100
                  : 0;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _addExpense(category),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(category),
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${expense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _totalBudget != null && _totalBudget! > 0
                                    ? expense / _totalBudget!
                                    : 0,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (_totalBudget != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Recommended: \$${(_totalBudget! * _getRecommendedPercentage(category)).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            // Recommendations Card
            Card(
              color: AppTheme.accentColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Budget Recommendations',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRecommendation('Accommodation', 30),
                    _buildRecommendation('Food', 20),
                    _buildRecommendation('Activities', 25),
                    _buildRecommendation('Transport', 15),
                    _buildRecommendation('Shopping', 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(String category, int percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(category),
          Text(
            '$percentage%',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'accommodation':
        return Icons.hotel;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'activities':
        return Icons.local_activity;
      case 'shopping':
        return Icons.shopping_bag;
      case 'emergency':
        return Icons.warning;
      default:
        return Icons.category;
    }
  }

  double _getRecommendedPercentage(String category) {
    switch (category.toLowerCase()) {
      case 'accommodation':
        return 0.30;
      case 'food':
        return 0.20;
      case 'activities':
        return 0.25;
      case 'transport':
        return 0.15;
      case 'shopping':
        return 0.10;
      default:
        return 0.0;
    }
  }
}
