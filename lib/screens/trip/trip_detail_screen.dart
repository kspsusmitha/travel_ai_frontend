import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../models/trip.dart';
import '../../models/expense.dart';
import '../itinerary/itinerary_builder_screen.dart';
import '../budget/budget_planner_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  // Mock expenses data
  final List<Expense> _expenses = [
    Expense(
      id: '1',
      tripId: '1',
      category: 'Accommodation',
      description: 'Hotel booking',
      amount: 500,
      paidBy: 'User1',
      sharedWith: ['User1', 'User2'],
      date: DateTime.now(),
      createdAt: DateTime.now(),
    ),
  ];

  double get _totalExpenses => _expenses.fold(0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.trip.name),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.info), text: 'Overview'),
              Tab(icon: Icon(Icons.route), text: 'Itinerary'),
              Tab(icon: Icon(Icons.receipt), text: 'Expenses'),
              Tab(icon: Icon(Icons.people), text: 'Travelers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            ItineraryBuilderScreen(trip: widget.trip),
            _buildExpensesTab(),
            _buildTravelersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.trip.destination,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Duration',
                    '${widget.trip.duration} days',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.date_range,
                    'Dates',
                    '${DateFormat('MMM dd').format(widget.trip.startDate)} - ${DateFormat('MMM dd, yyyy').format(widget.trip.endDate)}',
                  ),
                  if (widget.trip.budget != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.account_balance_wallet,
                      'Budget',
                      '\$${widget.trip.budget!.toStringAsFixed(0)}',
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.route,
                  title: 'Itinerary',
                  onTap: () {
                    // Switch to itinerary tab
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Budget',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BudgetPlannerScreen(trip: widget.trip),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.hotel,
                  title: 'Hotels',
                  onTap: () {
                    // TODO: Navigate to accommodation finder
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.local_activity,
                  title: 'Activities',
                  onTap: () {
                    // TODO: Navigate to activity finder
                  },
                ),
              ),
            ],
          ),
          if (widget.trip.description != null) ...[
            const SizedBox(height: 24),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(widget.trip.description!),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpensesTab() {
    return Column(
      children: [
        // Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.primaryColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  Text(
                    '\$${_totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (widget.trip.budget != null)
                Column(
                  children: [
                    const Text(
                      'Remaining',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    Text(
                      '\$${(widget.trip.budget! - _totalExpenses).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: (widget.trip.budget! - _totalExpenses) > 0
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          child: _expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No expenses yet',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) {
                    final expense = _expenses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Icon(
                            _getCategoryIcon(expense.category),
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        title: Text(expense.description),
                        subtitle: Text(
                          '${expense.category} • Paid by ${expense.paidBy}',
                        ),
                        trailing: Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Show add expense dialog
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Expense'),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: widget.trip.travelers.map((traveler) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(traveler[0].toUpperCase()),
                ),
                title: Text(traveler),
                subtitle: traveler == widget.trip.createdBy
                    ? const Text('Trip Creator')
                    : null,
                trailing: traveler == widget.trip.createdBy
                    ? const Chip(
                        label: Text('Admin'),
                        backgroundColor: AppTheme.primaryColor,
                      )
                    : null,
              );
            }).toList(),
          ),
        ),
        if (widget.trip.type == AppConstants.tripTypeGroup) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Show add traveler dialog
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Add Co-traveler'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Show share link dialog
            },
            icon: const Icon(Icons.link),
            label: const Text('Share Invite Link'),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
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
      default:
        return Icons.category;
    }
  }
}
