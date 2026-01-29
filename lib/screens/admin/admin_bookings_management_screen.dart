import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/action_dialog.dart';
import 'admin_booking_details_screen.dart';

/// Admin Bookings Management Screen
class AdminBookingsManagementScreen extends StatefulWidget {
  const AdminBookingsManagementScreen({super.key});

  @override
  State<AdminBookingsManagementScreen> createState() => _AdminBookingsManagementScreenState();
}

class _AdminBookingsManagementScreenState extends State<AdminBookingsManagementScreen> {
  String _selectedStatus = 'all';
  String _selectedPaymentStatus = 'all';

  // Dummy bookings data
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'referenceId': 'BK001234',
      'customerName': 'John Doe',
      'serviceName': 'Haircut & Styling',
      'bookingDate': DateTime.now().add(const Duration(days: 2)),
      'bookingTime': DateTime.now().add(const Duration(days: 2, hours: 2)),
      'status': 'pending',
      'paymentStatus': 'paid',
      'amount': 25.00,
    },
    {
      'id': '2',
      'referenceId': 'BK001235',
      'customerName': 'Jane Smith',
      'serviceName': 'Massage Therapy',
      'bookingDate': DateTime.now().add(const Duration(days: 3)),
      'bookingTime': DateTime.now().add(const Duration(days: 3, hours: 3)),
      'status': 'confirmed',
      'paymentStatus': 'paid',
      'amount': 60.00,
    },
    {
      'id': '3',
      'referenceId': 'BK001236',
      'customerName': 'Bob Johnson',
      'serviceName': 'Facial Treatment',
      'bookingDate': DateTime.now().add(const Duration(days: 1)),
      'bookingTime': DateTime.now().add(const Duration(days: 1, hours: 1)),
      'status': 'pending',
      'paymentStatus': 'unpaid',
      'amount': 45.00,
    },
    {
      'id': '4',
      'referenceId': 'BK001237',
      'customerName': 'Alice Williams',
      'serviceName': 'Manicure & Pedicure',
      'bookingDate': DateTime.now().subtract(const Duration(days: 1)),
      'bookingTime': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'status': 'cancelled',
      'paymentStatus': 'refunded',
      'amount': 35.00,
    },
  ];

  List<Map<String, dynamic>> get _filteredBookings {
    return _bookings.where((booking) {
      final statusMatch = _selectedStatus == 'all' || booking['status'] == _selectedStatus;
      final paymentMatch =
          _selectedPaymentStatus == 'all' || booking['paymentStatus'] == _selectedPaymentStatus;
      return statusMatch && paymentMatch;
    }).toList();
  }

  void _updateBookingStatus(String bookingId, String newStatus) {
    ActionDialog.show(
      context: context,
      title: 'Update Booking Status',
      message: 'Are you sure you want to change the status to ${newStatus.toUpperCase()}?',
      confirmText: 'Confirm',
      onConfirm: () {
        setState(() {
          final index = _bookings.indexWhere((b) => b['id'] == bookingId);
          if (index != -1) {
            _bookings[index]['status'] = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking status updated to $newStatus'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings Management'),
      ),
      body: Column(
        children: [
          // Filters
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All')),
                            DropdownMenuItem(value: 'pending', child: Text('Pending')),
                            DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPaymentStatus,
                          decoration: const InputDecoration(
                            labelText: 'Payment',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All')),
                            DropdownMenuItem(value: 'paid', child: Text('Paid')),
                            DropdownMenuItem(value: 'unpaid', child: Text('Unpaid')),
                            DropdownMenuItem(value: 'refunded', child: Text('Refunded')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentStatus = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Bookings List
          Expanded(
            child: _filteredBookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bookings found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _filteredBookings[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminBookingDetailsScreen(
                                  booking: booking,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking['referenceId'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            booking['customerName'],
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Chip(
                                      label: Text(
                                        booking['status'].toString().toUpperCase(),
                                      ),
                                      backgroundColor: _getStatusColor(
                                        booking['status'],
                                      ).withOpacity(0.2),
                                      labelStyle: TextStyle(
                                        color: _getStatusColor(booking['status']),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.spa,
                                      size: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        booking['serviceName'],
                                        style: TextStyle(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(
                                        booking['bookingDate'],
                                      ),
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('hh:mm a').format(
                                        booking['bookingTime'],
                                      ),
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${booking['amount'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (booking['status'] == 'pending')
                                          TextButton.icon(
                                            onPressed: () {
                                              _updateBookingStatus(
                                                booking['id'],
                                                'confirmed',
                                              );
                                            },
                                            icon: const Icon(Icons.check),
                                            label: const Text('Approve'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: AppTheme.successColor,
                                            ),
                                          ),
                                        if (booking['status'] == 'pending')
                                          const SizedBox(width: 8),
                                        if (booking['status'] != 'cancelled')
                                          TextButton.icon(
                                            onPressed: () {
                                              _updateBookingStatus(
                                                booking['id'],
                                                'cancelled',
                                              );
                                            },
                                            icon: const Icon(Icons.cancel),
                                            label: const Text('Cancel'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: AppTheme.errorColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
