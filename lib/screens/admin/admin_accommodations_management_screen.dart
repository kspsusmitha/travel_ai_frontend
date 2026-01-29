import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';
import 'admin_accommodation_details_screen.dart';

class AdminAccommodationsManagementScreen extends StatelessWidget {
  final bool isReadOnly;

  const AdminAccommodationsManagementScreen({
    super.key,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manage Accommodations'),
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
              final mockHotel = {
                'name': 'Hotel Grand #${index + 1}',
                'type': 'Resort',
                'price': (index + 1) * 100,
                'rating': 4.5,
                'category': index % 2 == 0 ? 'Premium' : 'Budget',
                'address': '123 Beach Rd, City #${index + 1}',
                'checkIn': '14:00',
                'checkOut': '11:00',
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
                          builder: (context) => AdminAccommodationDetailsScreen(
                            accommodation: mockHotel,
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
                      child: const Icon(Icons.hotel, color: Colors.white),
                    ),
                    title: Text(
                      mockHotel['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${mockHotel['rating']} Star • \$${mockHotel['price']}/night',
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
