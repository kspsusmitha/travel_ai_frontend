import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

/// Super Admin Reports & Logs Screen
class SuperAdminReportsScreen extends StatelessWidget {
  const SuperAdminReportsScreen({super.key});

  // Dummy reports data
  static final List<Map<String, dynamic>> _reports = [
    {
      'id': '1',
      'type': 'User Activity',
      'title': 'Daily User Registration Report',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'completed',
    },
    {
      'id': '2',
      'type': 'Booking Analysis',
      'title': 'Weekly Booking Statistics',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'completed',
    },
    {
      'id': '3',
      'type': 'System Log',
      'title': 'Error Log Analysis',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'pending',
    },
    {
      'id': '4',
      'type': 'Financial',
      'title': 'Monthly Revenue Report',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'completed',
    },
  ];

  static final List<Map<String, dynamic>> _logs = [
    {
      'id': '1',
      'action': 'Admin Login',
      'user': 'admin1@example.com',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'success',
    },
    {
      'id': '2',
      'action': 'User Deactivated',
      'user': 'admin2@example.com',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'success',
    },
    {
      'id': '3',
      'action': 'Booking Approved',
      'user': 'admin1@example.com',
      'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
      'status': 'success',
    },
    {
      'id': '4',
      'action': 'Failed Login Attempt',
      'user': 'unknown@example.com',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'status': 'failed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports & Logs'),
          backgroundColor: AppTheme.secondaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assessment), text: 'Reports'),
              Tab(icon: Icon(Icons.history), text: 'Activity Logs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportsTab(),
            _buildLogsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getReportTypeColor(report['type']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getReportTypeIcon(report['type']),
                color: _getReportTypeColor(report['type']),
              ),
            ),
            title: Text(
              report['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Type: ${report['type']}'),
                const SizedBox(height: 4),
                Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(report['date'])}',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: Text(
                    report['status'].toString().toUpperCase(),
                  ),
                  backgroundColor: report['status'] == 'completed'
                      ? AppTheme.successColor.withOpacity(0.2)
                      : AppTheme.accentColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: report['status'] == 'completed'
                        ? AppTheme.successColor
                        : AppTheme.accentColor,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading ${report['title']}...'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: log['status'] == 'success'
                    ? AppTheme.successColor.withOpacity(0.1)
                    : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                log['status'] == 'success' ? Icons.check_circle : Icons.error,
                color: log['status'] == 'success'
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
              ),
            ),
            title: Text(
              log['action'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('User: ${log['user']}'),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy hh:mm a').format(log['timestamp']),
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: Chip(
              label: Text(
                log['status'].toString().toUpperCase(),
              ),
              backgroundColor: log['status'] == 'success'
                  ? AppTheme.successColor.withOpacity(0.2)
                  : AppTheme.errorColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: log['status'] == 'success'
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
                fontSize: 10,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getReportTypeIcon(String type) {
    switch (type) {
      case 'User Activity':
        return Icons.people;
      case 'Booking Analysis':
        return Icons.event_note;
      case 'System Log':
        return Icons.bug_report;
      case 'Financial':
        return Icons.account_balance_wallet;
      default:
        return Icons.assessment;
    }
  }

  Color _getReportTypeColor(String type) {
    switch (type) {
      case 'User Activity':
        return AppTheme.primaryColor;
      case 'Booking Analysis':
        return AppTheme.secondaryColor;
      case 'System Log':
        return AppTheme.accentColor;
      case 'Financial':
        return AppTheme.successColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}
