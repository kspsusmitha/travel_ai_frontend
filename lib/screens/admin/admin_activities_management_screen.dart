import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';
import 'admin_activity_details_screen.dart';

class AdminActivitiesManagementScreen extends StatelessWidget {
  final bool isReadOnly;

  const AdminActivitiesManagementScreen({super.key, this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Activities'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A237E), // Deep Indigo
              AppTheme.primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5, // Mock count
            itemBuilder: (context, index) {
              final mockActivity = {
                'name': 'Travel Activity #${index + 1}',
                'location': 'City #${index + 1}',
                'price': (index + 1) * 50.0,
                'duration': '${index + 2} hours',
                'description':
                    'Experience the best of City #${index + 1} with a guided tour aimed at providing unforgettable memories.',
                'coordinates': '-8.72, 115.17',
              };

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Glassmorphism(
                  blur: 10,
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminActivityDetailsScreen(
                            activity: mockActivity,
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_activity,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      mockActivity['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Location: ${mockActivity['location']} • Est. Time: ${mockActivity['duration']}',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    trailing: isReadOnly
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white70,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppTheme.errorColor,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: isReadOnly
          ? null
          : FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppTheme.accentColor,
              child: const Icon(Icons.add),
            ),
    );
  }
}
