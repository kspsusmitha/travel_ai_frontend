import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/guest_booking.dart';
import '../../models/travel_package.dart';
import '../guest/guest_landing_screen.dart';
import '../auth/login_screen.dart';

/// Guest Booking Confirmation Screen
class GuestConfirmationScreen extends StatelessWidget {
  final GuestBooking booking;
  final TravelPackage package;
  final int numberOfTravelers;
  final DateTime startDate;
  final DateTime endDate;

  const GuestConfirmationScreen({
    super.key,
    required this.booking,
    required this.package,
    required this.numberOfTravelers,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Success Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(height: 32),
              // Success Message
              Text(
                'Booking Confirmed!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your booking has been successfully created',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Booking Details Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Reference ID',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.referenceId,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 32),
                      _buildDetailRow(
                        icon: Icons.person,
                        label: 'Guest Name',
                        value: booking.guestName,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.phone,
                        label: 'Phone Number',
                        value: booking.phoneNumber,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.flight_takeoff,
                        label: 'Travel Package',
                        value: booking.serviceName,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.location_on,
                        label: 'Destination',
                        value: package.destination,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.people,
                        label: 'Number of Travelers',
                        value: '$numberOfTravelers ${numberOfTravelers == 1 ? 'person' : 'people'}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Trip Start Date',
                        value: DateFormat('EEEE, MMMM dd, yyyy').format(startDate),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.event,
                        label: 'Trip End Date',
                        value: DateFormat('EEEE, MMMM dd, yyyy').format(endDate),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.access_time,
                        label: 'Duration',
                        value: '${endDate.difference(startDate).inDays} days',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.account_balance_wallet,
                        label: 'Total Amount',
                        value: '\$${booking.totalAmount.toStringAsFixed(2)} (${numberOfTravelers}x \$${package.price.toStringAsFixed(0)})',
                        isAmount: true,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _getStatusColor(booking.status),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Status: ${booking.status.toUpperCase()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(booking.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GuestLandingScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Travel Packages'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Login / Register'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAmount = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isAmount ? AppTheme.primaryColor : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.accentColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}
