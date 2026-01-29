import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/action_dialog.dart';

/// Admin Booking Details Screen
class AdminBookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const AdminBookingDetailsScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reference ID Card
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Reference ID',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Booking Information
            Text(
              'Booking Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Customer Name',
              booking['customerName'],
              Icons.person,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              'Service',
              booking['serviceName'],
              Icons.spa,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              'Date',
              DateFormat('EEEE, MMMM dd, yyyy').format(booking['bookingDate']),
              Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              'Time',
              DateFormat('hh:mm a').format(booking['bookingTime']),
              Icons.access_time,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              'Amount',
              '\$${booking['amount'].toStringAsFixed(2)}',
              Icons.account_balance_wallet,
              isAmount: true,
            ),
            const SizedBox(height: 24),
            // Status Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: _getStatusColor(booking['status']).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: _getStatusColor(booking['status']),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
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
                  child: Card(
                    color: _getPaymentStatusColor(booking['paymentStatus']).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.payment,
                            color: _getPaymentStatusColor(booking['paymentStatus']),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Payment',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking['paymentStatus'].toString().toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getPaymentStatusColor(booking['paymentStatus']),
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
            // Action Buttons
            if (booking['status'] == 'pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ActionDialog.show(
                      context: context,
                      title: 'Approve Booking',
                      message: 'Are you sure you want to approve this booking?',
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            if (booking['status'] == 'pending') const SizedBox(height: 12),
            if (booking['status'] != 'cancelled')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ActionDialog.show(
                      context: context,
                      title: 'Cancel Booking',
                      message: 'Are you sure you want to cancel this booking?',
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isAmount = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
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
        ),
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
        return AppTheme.textSecondary;
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
        return AppTheme.textSecondary;
    }
  }
}
