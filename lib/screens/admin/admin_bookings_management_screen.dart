import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';
import '../../common_widgets/action_dialog.dart';
import 'admin_booking_details_screen.dart';

/// Admin Bookings Management Screen
class AdminBookingsManagementScreen extends StatefulWidget {
  final bool isReadOnly;

  const AdminBookingsManagementScreen({super.key, this.isReadOnly = false});

  @override
  State<AdminBookingsManagementScreen> createState() =>
      _AdminBookingsManagementScreenState();
}

class _AdminBookingsManagementScreenState
    extends State<AdminBookingsManagementScreen> {
  String _selectedStatus = 'all';
  String _selectedPaymentStatus = 'all';

  // Dummy bookings data
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'referenceId': 'BK001234',
      'customerName': 'John Doe',
      'tripName': 'Bali Adventure',
      'bookingDate': DateTime.now().add(const Duration(days: 2)),
      'bookingTime': DateTime.now().add(const Duration(days: 2, hours: 2)),
      'status': 'pending',
      'paymentStatus': 'paid',
      'amount': 1250.00,
      'activity': {
        'name': 'Scuba Diving',
        'location': 'Nusa Penida, Bali',
        'price': 150.00,
        'date': DateTime.now().add(const Duration(days: 3)),
      },
      'accommodation': {
        'name': 'Grand Hyatt Bali',
        'type': 'Resort',
        'checkIn': DateTime.now().add(const Duration(days: 2)),
        'checkOut': DateTime.now().add(const Duration(days: 7)),
        'price': 800.00,
      },
      'route': {
        'from': 'Jakarta (CGK)',
        'to': 'Denpasar (DPS)',
        'mode': 'Flight',
        'price': 300.00,
      },
    },
    {
      'id': '2',
      'referenceId': 'BK001235',
      'customerName': 'Jane Smith',
      'tripName': 'Tokyo Explorer',
      'bookingDate': DateTime.now().add(const Duration(days: 3)),
      'bookingTime': DateTime.now().add(const Duration(days: 3, hours: 3)),
      'status': 'confirmed',
      'paymentStatus': 'paid',
      'amount': 2500.00,
      'activity': {
        'name': 'Mount Fuji Tour',
        'location': 'Shizuoka',
        'price': 200.00,
        'date': DateTime.now().add(const Duration(days: 5)),
      },
      'accommodation': {
        'name': 'Shinjuku Prince Hotel',
        'type': 'Hotel',
        'checkIn': DateTime.now().add(const Duration(days: 3)),
        'checkOut': DateTime.now().add(const Duration(days: 8)),
        'price': 1500.00,
      },
      'route': {
        'from': 'Narita (NRT)',
        'to': 'Tokyo St.',
        'mode': 'Train',
        'price': 50.00,
      },
    },
    {
      'id': '3',
      'referenceId': 'BK001236',
      'customerName': 'Bob Johnson',
      'tripName': 'Paris Getaway',
      'bookingDate': DateTime.now().add(const Duration(days: 1)),
      'bookingTime': DateTime.now().add(const Duration(days: 1, hours: 1)),
      'status': 'pending',
      'paymentStatus': 'unpaid',
      'amount': 3200.00,
      'activity': {
        'name': 'Louvre Museum Tour',
        'location': 'Paris, France',
        'price': 80.00,
        'date': DateTime.now().add(const Duration(days: 2)),
      },
      'accommodation': {
        'name': 'Hotel Ritz Paris',
        'type': 'Luxury Hotel',
        'checkIn': DateTime.now().add(const Duration(days: 1)),
        'checkOut': DateTime.now().add(const Duration(days: 4)),
        'price': 2800.00,
      },
      'route': {
        'from': 'London (LHR)',
        'to': 'Paris (CDG)',
        'mode': 'Flight',
        'price': 250.00,
      },
    },
    {
      'id': '4',
      'referenceId': 'BK001237',
      'customerName': 'Alice Williams',
      'tripName': 'NYC City Break',
      'bookingDate': DateTime.now().subtract(const Duration(days: 1)),
      'bookingTime': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      'status': 'cancelled',
      'paymentStatus': 'refunded',
      'amount': 800.00,
      'activity': {
        'name': 'Broadway Show',
        'location': 'Times Square, NYC',
        'price': 120.00,
        'date': DateTime.now().subtract(const Duration(hours: 12)),
      },
      'accommodation': {
        'name': 'Marriott Marquis',
        'type': 'Hotel',
        'checkIn': DateTime.now().subtract(const Duration(days: 2)),
        'checkOut': DateTime.now().add(const Duration(days: 1)),
        'price': 600.00,
      },
      'route': {
        'from': 'Boston',
        'to': 'New York',
        'mode': 'Train',
        'price': 80.00,
      },
    },
  ];

  List<Map<String, dynamic>> get _filteredBookings {
    return _bookings.where((booking) {
      final statusMatch =
          _selectedStatus == 'all' || booking['status'] == _selectedStatus;
      final paymentMatch =
          _selectedPaymentStatus == 'all' ||
          booking['paymentStatus'] == _selectedPaymentStatus;
      return statusMatch && paymentMatch;
    }).toList();
  }

  void _updateBookingStatus(String bookingId, String newStatus) {
    ActionDialog.show(
      context: context,
      title: 'Update Booking Status',
      message:
          'Are you sure you want to change the status to ${newStatus.toUpperCase()}?',
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Bookings Management'),
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
          child: Column(
            children: [
              // Filters
              Padding(
                padding: const EdgeInsets.all(16),
                child: Glassmorphism(
                  blur: 10,
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildGlassDropdown(
                                value: _selectedStatus,
                                label: 'Status',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'all',
                                    child: Text('All'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'pending',
                                    child: Text('Pending'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'confirmed',
                                    child: Text('Confirmed'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'cancelled',
                                    child: Text('Cancelled'),
                                  ),
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
                              child: _buildGlassDropdown(
                                value: _selectedPaymentStatus,
                                label: 'Payment',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'all',
                                    child: Text('All'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'paid',
                                    child: Text('Paid'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'unpaid',
                                    child: Text('Unpaid'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'refunded',
                                    child: Text('Refunded'),
                                  ),
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
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No bookings found',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = _filteredBookings[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Glassmorphism(
                              blur: 10,
                              opacity: 0.1,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminBookingDetailsScreen(
                                            booking: booking,
                                            isReadOnly: widget.isReadOnly,
                                          ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking['referenceId'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  booking['customerName'],
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                booking['status'],
                                              ).withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: _getStatusColor(
                                                  booking['status'],
                                                ).withOpacity(0.5),
                                              ),
                                            ),
                                            child: Text(
                                              booking['status']
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: _getStatusColor(
                                                  booking['status'],
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        height: 24,
                                        color: Colors.white24,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.spa,
                                            size: 16,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              booking['tripName'],
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
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
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat(
                                              'MMM dd, yyyy',
                                            ).format(booking['bookingDate']),
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat(
                                              'hh:mm a',
                                            ).format(booking['bookingTime']),
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${booking['amount'].toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.accentColor,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (!widget.isReadOnly &&
                                                  booking['status'] ==
                                                      'pending')
                                                IconButton(
                                                  onPressed: () {
                                                    _updateBookingStatus(
                                                      booking['id'],
                                                      'confirmed',
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.check_circle,
                                                    color:
                                                        AppTheme.successColor,
                                                  ),
                                                  tooltip: 'Approve',
                                                ),
                                              if (!widget.isReadOnly &&
                                                  booking['status'] !=
                                                      'cancelled')
                                                IconButton(
                                                  onPressed: () {
                                                    _updateBookingStatus(
                                                      booking['id'],
                                                      'cancelled',
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    color: AppTheme.errorColor,
                                                  ),
                                                  tooltip: 'Cancel',
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown({
    required String value,
    required String label,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items,
              onChanged: onChanged,
              dropdownColor: const Color(
                0xFF1A1A2E,
              ), // Dark background for dropdown
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }
}
