import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';
import 'super_admin_manage_admins_screen.dart';
import 'super_admin_system_config_screen.dart';
import 'super_admin_reports_screen.dart';
import 'super_admin_ai_supervision_screen.dart';
import '../auth/login_screen.dart';
import '../admin/admin_activities_management_screen.dart';
import '../admin/admin_accommodations_management_screen.dart';
import '../admin/admin_routes_management_screen.dart';
import '../admin/admin_bookings_management_screen.dart';

/// Super Admin Dashboard Screen - Redesigned with Glassmorphism and Animations
class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Animation<Offset>> _slideAnimations;

  // Dummy statistics
  static const int totalAdmins = 12;
  static const int totalUsers = 1247;
  static const int totalBookings = 3421;
  static const int systemHealth = 98;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Create staggered animations for different sections
    _slideAnimations = List.generate(
      6,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index * 0.1,
                0.5 + (index * 0.1),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A237E), // Deep Indigo
              AppTheme.primaryColor,
              const Color(0xFF311B92), // Deep Purple
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  SlideTransition(
                    position: _slideAnimations[0],
                    child: Glassmorphism(
                      blur: 15,
                      opacity: 0.1,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.security,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const Text(
                                    'Super Administrator',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // System Overview Grid
                  SlideTransition(
                    position: _slideAnimations[1],
                    child: _buildSectionTitle('System Overview'),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _slideAnimations[2],
                    child: _buildStatGrid(),
                  ),
                  const SizedBox(height: 32),

                  // Travel Data Oversight
                  SlideTransition(
                    position: _slideAnimations[3],
                    child: _buildSectionTitle('Travel Data Oversight'),
                  ),
                  const SizedBox(height: 16),
                  SlideTransition(
                    position: _slideAnimations[4],
                    child: Column(
                      children: [
                        _buildActionCard(
                          icon: Icons.local_activity,
                          title: 'Activities',
                          subtitle: 'Monitor system-wide activities',
                          color: Colors.orange,
                          onTap: () => _navigateTo(
                            const AdminActivitiesManagementScreen(
                              isReadOnly: true,
                            ),
                          ),
                        ),
                        _buildActionCard(
                          icon: Icons.hotel,
                          title: 'Accommodations',
                          subtitle: 'Monitor registered hotels and stays',
                          color: Colors.teal,
                          onTap: () => _navigateTo(
                            const AdminAccommodationsManagementScreen(
                              isReadOnly: true,
                            ),
                          ),
                        ),
                        _buildActionCard(
                          icon: Icons.route,
                          title: 'Travel Routes',
                          subtitle: 'Inspect available travel routes',
                          color: Colors.purple,
                          onTap: () => _navigateTo(
                            const AdminRoutesManagementScreen(isReadOnly: true),
                          ),
                        ),
                        _buildActionCard(
                          icon: Icons.confirmation_number,
                          title: 'Global Bookings',
                          subtitle: 'Audit user bookings and payments',
                          color: Colors.blue,
                          onTap: () => _navigateTo(
                            const AdminBookingsManagementScreen(
                              isReadOnly: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  // System Management
                  SlideTransition(
                    position: _slideAnimations[5],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('System Management'),
                        const SizedBox(height: 16),
                        _buildActionCard(
                          icon: Icons.psychology,
                          title: 'AI Supervision',
                          subtitle: 'Monitor AI trip planning usage',
                          color: Colors.deepPurpleAccent,
                          onTap: () => _navigateTo(
                            const SuperAdminAISupervisionScreen(),
                          ),
                        ),
                        _buildActionCard(
                          icon: Icons.admin_panel_settings,
                          title: 'Manage Administrators',
                          subtitle: 'Create, edit, or remove admin accounts',
                          color: AppTheme.secondaryColor,
                          onTap: () =>
                              _navigateTo(const SuperAdminManageAdminsScreen()),
                        ),
                        _buildActionCard(
                          icon: Icons.settings,
                          title: 'System Configuration',
                          subtitle: 'Configure system settings and parameters',
                          color: AppTheme.primaryColor,
                          onTap: () =>
                              _navigateTo(const SuperAdminSystemConfigScreen()),
                        ),
                        _buildActionCard(
                          icon: Icons.assessment,
                          title: 'Reports & Logs',
                          subtitle: 'View system reports and activity logs',
                          color: AppTheme.accentColor,
                          onTap: () =>
                              _navigateTo(const SuperAdminReportsScreen()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          'Admins',
          totalAdmins.toString(),
          Icons.admin_panel_settings,
          AppTheme.secondaryColor,
        ),
        _buildStatCard(
          'Users',
          totalUsers.toString(),
          Icons.people,
          AppTheme.primaryColor,
        ),
        _buildStatCard(
          'Bookings',
          totalBookings.toString(),
          Icons.event_note,
          AppTheme.accentColor,
        ),
        _buildStatCard(
          'Health',
          '$systemHealth%',
          Icons.health_and_safety,
          AppTheme.successColor,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Glassmorphism(
      blur: 10,
      opacity: 0.1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Glassmorphism(
        blur: 10,
        opacity: 0.1,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
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
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F3D),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout from the Super Admin panel?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
