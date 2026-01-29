import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/stat_card.dart';
import 'super_admin_manage_admins_screen.dart';
import 'super_admin_system_config_screen.dart';
import 'super_admin_reports_screen.dart';
import '../auth/login_screen.dart';

/// Super Admin Dashboard Screen
class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  // Dummy statistics
  static const int totalAdmins = 12;
  static const int totalUsers = 1247;
  static const int totalBookings = 3421;
  static const int systemHealth = 98;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        backgroundColor: AppTheme.secondaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              color: AppTheme.secondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.security,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, Super Administrator',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'System-level control and management',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // System Overview
            Text(
              'System Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StatCard(
                  title: 'Total Admins',
                  value: totalAdmins.toString(),
                  icon: Icons.admin_panel_settings,
                  color: AppTheme.secondaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuperAdminManageAdminsScreen(),
                      ),
                    );
                  },
                ),
                StatCard(
                  title: 'Total Users',
                  value: totalUsers.toString(),
                  icon: Icons.people,
                  color: AppTheme.primaryColor,
                ),
                StatCard(
                  title: 'Total Bookings',
                  value: totalBookings.toString(),
                  icon: Icons.event_note,
                  color: AppTheme.accentColor,
                ),
                StatCard(
                  title: 'System Health',
                  value: '$systemHealth%',
                  icon: Icons.health_and_safety,
                  color: AppTheme.successColor,
                ),
              ],
            ),
            const SizedBox(height: 32),
            // System Management
            Text(
              'System Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.admin_panel_settings,
              title: 'Manage Administrators',
              subtitle: 'Create, edit, or remove admin accounts',
              color: AppTheme.secondaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuperAdminManageAdminsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              icon: Icons.settings,
              title: 'System Configuration',
              subtitle: 'Configure system settings and parameters',
              color: AppTheme.primaryColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuperAdminSystemConfigScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionCard(
              context,
              icon: Icons.assessment,
              title: 'Reports & Logs',
              subtitle: 'View system reports and activity logs',
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuperAdminReportsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
