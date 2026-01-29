import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/action_dialog.dart';

/// Super Admin Manage Administrators Screen
class SuperAdminManageAdminsScreen extends StatefulWidget {
  const SuperAdminManageAdminsScreen({super.key});

  @override
  State<SuperAdminManageAdminsScreen> createState() => _SuperAdminManageAdminsScreenState();
}

class _SuperAdminManageAdminsScreenState extends State<SuperAdminManageAdminsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy admins data
  final List<Map<String, dynamic>> _admins = [
    {
      'id': '1',
      'name': 'Admin One',
      'email': 'admin1@example.com',
      'role': 'Administrator',
      'isActive': true,
      'createdDate': '2024-01-15',
      'lastLogin': '2024-03-20',
    },
    {
      'id': '2',
      'name': 'Admin Two',
      'email': 'admin2@example.com',
      'role': 'Administrator',
      'isActive': true,
      'createdDate': '2024-02-10',
      'lastLogin': '2024-03-19',
    },
    {
      'id': '3',
      'name': 'Admin Three',
      'email': 'admin3@example.com',
      'role': 'Administrator',
      'isActive': false,
      'createdDate': '2024-01-20',
      'lastLogin': '2024-03-15',
    },
  ];

  List<Map<String, dynamic>> get _filteredAdmins {
    if (_searchController.text.isEmpty) {
      return _admins;
    }
    final query = _searchController.text.toLowerCase();
    return _admins.where((admin) {
      return admin['name'].toString().toLowerCase().contains(query) ||
          admin['email'].toString().toLowerCase().contains(query);
    }).toList();
  }

  void _toggleAdminStatus(int index) {
    final admin = _filteredAdmins[index];
    final newStatus = !admin['isActive'] as bool;
    final action = newStatus ? 'activate' : 'deactivate';

    ActionDialog.show(
      context: context,
      title: '${action.capitalize()} Administrator',
      message: 'Are you sure you want to $action ${admin['name']}?',
      confirmText: action.capitalize(),
      confirmColor: newStatus ? AppTheme.successColor : AppTheme.errorColor,
      onConfirm: () {
        setState(() {
          final originalIndex = _admins.indexWhere((a) => a['id'] == admin['id']);
          if (originalIndex != -1) {
            _admins[originalIndex]['isActive'] = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Administrator ${action}d successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      },
    );
  }

  void _deleteAdmin(int index) {
    final admin = _filteredAdmins[index];

    ActionDialog.show(
      context: context,
      title: 'Delete Administrator',
      message: 'Are you sure you want to permanently delete ${admin['name']}? This action cannot be undone.',
      confirmText: 'Delete',
      confirmColor: AppTheme.errorColor,
      onConfirm: () {
        setState(() {
          _admins.removeWhere((a) => a['id'] == admin['id']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Administrator deleted successfully'),
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
        title: const Text('Manage Administrators'),
        backgroundColor: AppTheme.secondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Show add admin dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add admin feature coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search administrators...',
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
          // Admins List
          Expanded(
            child: _filteredAdmins.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No administrators found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAdmins.length,
                    itemBuilder: (context, index) {
                      final admin = _filteredAdmins[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.admin_panel_settings,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                          title: Text(
                            admin['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(admin['email']),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      admin['isActive'] ? 'Active' : 'Inactive',
                                    ),
                                    backgroundColor: admin['isActive']
                                        ? AppTheme.successColor.withOpacity(0.2)
                                        : AppTheme.errorColor.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: admin['isActive']
                                          ? AppTheme.successColor
                                          : AppTheme.errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  admin['isActive'] ? Icons.block : Icons.check_circle,
                                  color: admin['isActive']
                                      ? AppTheme.errorColor
                                      : AppTheme.successColor,
                                ),
                                onPressed: () => _toggleAdminStatus(index),
                                tooltip: admin['isActive'] ? 'Deactivate' : 'Activate',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                                onPressed: () => _deleteAdmin(index),
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
