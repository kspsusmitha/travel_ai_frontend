import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final String _userName = 'John Doe';
  final String _userEmail = 'john.doe@example.com';
  final String _userImage = ''; // Placeholder for profile image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: _userImage.isEmpty
                        ? Text(
                            _userName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          )
                        : ClipOval(
                            child: Image.network(_userImage),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Menu Items
            _buildMenuSection(
              title: 'Account',
              items: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    // TODO: Navigate to notifications settings
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy & Security',
                  onTap: () {
                    // TODO: Navigate to privacy settings
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildMenuSection(
              title: 'Preferences',
              items: [
                _buildMenuItem(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: const Text('English'),
                  onTap: () {
                    // TODO: Show language selection
                  },
                ),
                _buildMenuItem(
                  icon: Icons.currency_exchange,
                  title: 'Currency',
                  trailing: const Text('USD'),
                  onTap: () {
                    // TODO: Show currency selection
                  },
                ),
                _buildMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  trailing: const Text('Light'),
                  onTap: () {
                    // TODO: Show theme selection
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildMenuSection(
              title: 'Support',
              items: [
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'TripMate',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 TripMate',
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  textColor: AppTheme.errorColor,
                  onTap: () {
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
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppTheme.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
