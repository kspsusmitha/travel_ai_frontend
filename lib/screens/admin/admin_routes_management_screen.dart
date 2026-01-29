import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';
import 'admin_route_details_screen.dart';

class AdminRoutesManagementScreen extends StatelessWidget {
  final bool isReadOnly;

  const AdminRoutesManagementScreen({super.key, this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Routes'),
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
            itemCount: 5,
            itemBuilder: (context, index) {
              final mockRoute = {
                'from': 'City A #${index + 1}',
                'to': 'City B #${index + 1}',
                'fromCode': 'CTA',
                'toCode': 'CTB',
                'mode': 'Flight',
                'price': 150.0 + (index * 10),
                'duration': '2h 30m',
                'description':
                    'Direct flight with premium airlines, meals included.',
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
                          builder: (context) =>
                              AdminRouteDetailsScreen(route: mockRoute),
                        ),
                      );
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.route, color: Colors.white),
                    ),
                    title: Text(
                      '${mockRoute['from']} -> ${mockRoute['to']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${mockRoute['mode']} • ${mockRoute['duration']} • \$${mockRoute['price']}',
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
