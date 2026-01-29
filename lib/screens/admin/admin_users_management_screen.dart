import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/action_dialog.dart';

/// Admin Users Management Screen
class AdminUsersManagementScreen extends StatefulWidget {
  const AdminUsersManagementScreen({super.key});

  @override
  State<AdminUsersManagementScreen> createState() => _AdminUsersManagementScreenState();
}

class _AdminUsersManagementScreenState extends State<AdminUsersManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy users data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+1 234-567-8900',
      'isActive': true,
      'joinedDate': '2024-01-15',
      'totalBookings': 12,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '+1 234-567-8901',
      'isActive': true,
      'joinedDate': '2024-02-20',
      'totalBookings': 8,
    },
    {
      'id': '3',
      'name': 'Bob Johnson',
      'email': 'bob.johnson@example.com',
      'phone': '+1 234-567-8902',
      'isActive': false,
      'joinedDate': '2024-01-10',
      'totalBookings': 3,
    },
    {
      'id': '4',
      'name': 'Alice Williams',
      'email': 'alice.williams@example.com',
      'phone': '+1 234-567-8903',
      'isActive': true,
      'joinedDate': '2024-03-05',
      'totalBookings': 15,
    },
    {
      'id': '5',
      'name': 'Charlie Brown',
      'email': 'charlie.brown@example.com',
      'phone': '+1 234-567-8904',
      'isActive': false,
      'joinedDate': '2023-12-01',
      'totalBookings': 0,
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchController.text.isEmpty) {
      return _users;
    }
    final query = _searchController.text.toLowerCase();
    return _users.where((user) {
      return user['name'].toString().toLowerCase().contains(query) ||
          user['email'].toString().toLowerCase().contains(query);
    }).toList();
  }

  void _toggleUserStatus(int index) {
    final user = _filteredUsers[index];
    final newStatus = !user['isActive'] as bool;
    final action = newStatus ? 'activate' : 'deactivate';

    ActionDialog.show(
      context: context,
      title: '${action.capitalize()} User',
      message: 'Are you sure you want to $action ${user['name']}?',
      confirmText: action.capitalize(),
      confirmColor: newStatus ? AppTheme.successColor : AppTheme.errorColor,
      onConfirm: () {
        setState(() {
          final originalIndex = _users.indexWhere((u) => u['id'] == user['id']);
          if (originalIndex != -1) {
            _users[originalIndex]['isActive'] = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ${action}d successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users by name or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // Users Table
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Bookings')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _filteredUsers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final user = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(user['name'])),
                            DataCell(Text(user['email'])),
                            DataCell(Text(user['phone'])),
                            DataCell(
                              Chip(
                                label: Text(
                                  user['isActive'] ? 'Active' : 'Inactive',
                                ),
                                backgroundColor: user['isActive']
                                    ? AppTheme.successColor.withOpacity(0.2)
                                    : AppTheme.errorColor.withOpacity(0.2),
                                labelStyle: TextStyle(
                                  color: user['isActive']
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                ),
                              ),
                            ),
                            DataCell(Text(user['totalBookings'].toString())),
                            DataCell(
                              IconButton(
                                icon: Icon(
                                  user['isActive']
                                      ? Icons.block
                                      : Icons.check_circle,
                                  color: user['isActive']
                                      ? AppTheme.errorColor
                                      : AppTheme.successColor,
                                ),
                                onPressed: () => _toggleUserStatus(index),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
