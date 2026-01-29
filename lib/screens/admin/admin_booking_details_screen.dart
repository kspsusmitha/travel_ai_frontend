import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/action_dialog.dart';
import '../../common_widgets/glassmorphism.dart';

/// Admin Booking Details Screen
class AdminBookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isReadOnly;

  const AdminBookingDetailsScreen({
    super.key,
    required this.booking,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A237E), // Deep Indigo
              AppTheme.primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Reference ID and Amount
                AnimatedGlassCard(
                  delay: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Reference ID',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          booking['referenceId'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '\$${booking['amount'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Customer & Trip Info
                AnimatedGlassCard(
                  delay: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Trip Overview'),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          Icons.person,
                          'Customer',
                          booking['customerName'],
                        ),
                        _buildDetailRow(
                          Icons.location_on,
                          'Trip Name',
                          booking['tripName'],
                        ),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Date',
                          DateFormat(
                            'EEEE, MMM dd, yyyy',
                          ).format(booking['bookingDate']),
                        ),
                        _buildDetailRow(
                          Icons.access_time,
                          'Time',
                          DateFormat('hh:mm a').format(booking['bookingTime']),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sub-Resources: Activity
                if (booking['activity'] != null)
                  AnimatedGlassCard(
                    delay: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Activity Details',
                            icon: Icons.local_activity,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.confirmation_number,
                            'Activity',
                            booking['activity']['name'],
                          ),
                          _buildDetailRow(
                            Icons.place,
                            'Location',
                            booking['activity']['location'],
                          ),
                          _buildDetailRow(
                            Icons.event,
                            'Date',
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(booking['activity']['date']),
                          ),
                          _buildDetailRow(
                            Icons.attach_money,
                            'Price',
                            '\$${booking['activity']['price']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                if (booking['activity'] != null) const SizedBox(height: 20),

                // Sub-Resources: Accommodation
                if (booking['accommodation'] != null)
                  AnimatedGlassCard(
                    delay: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Accommodation',
                            icon: Icons.hotel,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.business,
                            'Hotel',
                            booking['accommodation']['name'],
                          ),
                          _buildDetailRow(
                            Icons.category,
                            'Type',
                            booking['accommodation']['type'],
                          ),
                          _buildDetailRow(
                            Icons.login,
                            'Check-In',
                            DateFormat(
                              'MMM dd',
                            ).format(booking['accommodation']['checkIn']),
                          ),
                          _buildDetailRow(
                            Icons.logout,
                            'Check-Out',
                            DateFormat(
                              'MMM dd',
                            ).format(booking['accommodation']['checkOut']),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (booking['accommodation'] != null)
                  const SizedBox(height: 20),

                // Sub-Resources: Route
                if (booking['route'] != null)
                  AnimatedGlassCard(
                    delay: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Travel Route',
                            icon: Icons.directions,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.flight_takeoff,
                            'From',
                            booking['route']['from'],
                          ),
                          _buildDetailRow(
                            Icons.flight_land,
                            'To',
                            booking['route']['to'],
                          ),
                          _buildDetailRow(
                            Icons.commute,
                            'Mode',
                            booking['route']['mode'],
                          ),
                        ],
                      ),
                    ),
                  ),

                if (booking['route'] != null) const SizedBox(height: 20),

                // Status & Actions
                Row(
                  children: [
                    Expanded(
                      child: AnimatedGlassCard(
                        delay: const Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking['status'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(booking['status']),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedGlassCard(
                        delay: const Duration(milliseconds: 650),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Payment',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking['paymentStatus']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getPaymentStatusColor(
                                    booking['paymentStatus'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Admin Actions
                if (!isReadOnly && booking['status'] == 'pending')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ActionDialog.show(
                          context: context,
                          title: 'Approve Booking',
                          message:
                              'Are you sure you want to approve this booking?',
                          confirmText: 'Approve',
                          confirmColor: AppTheme.successColor,
                          onConfirm: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Booking approved successfully'),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Approve Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                if (!isReadOnly && booking['status'] != 'cancelled') ...[
                  if (booking['status'] == 'pending')
                    const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ActionDialog.show(
                          context: context,
                          title: 'Cancel Booking',
                          message:
                              'Are you sure you want to cancel this booking?',
                          confirmText: 'Cancel',
                          confirmColor: AppTheme.errorColor,
                          onConfirm: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Booking cancelled successfully'),
                                backgroundColor: AppTheme.errorColor,
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Booking'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
        return Colors.white70;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppTheme.successColor;
      case 'unpaid':
        return AppTheme.accentColor;
      case 'refunded':
        return AppTheme.errorColor;
      default:
        return Colors.white70;
    }
  }
}
