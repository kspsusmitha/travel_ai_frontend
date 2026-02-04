import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/booking.dart';
import '../../models/travel_activity.dart';
import '../../models/accommodation.dart';
import '../../models/travel_route.dart';
import '../../services/api_service.dart';
import '../itinerary/itinerary_builder_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Booking booking;

  const TripDetailScreen({super.key, required this.booking});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<TravelActivity> _activities = [];
  List<Accommodation> _accommodations = [];
  List<TravelRoute> _routes = [];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<Future> futures = [];

      // Fetch Activities
      if (widget.booking.bookedActivities != null) {
        for (var ba in widget.booking.bookedActivities!) {
          futures.add(ApiService.getActivity(ba.activityId));
        }
      }

      // Fetch Accommodations
      if (widget.booking.bookedAccommodations != null) {
        for (var bacc in widget.booking.bookedAccommodations!) {
          futures.add(ApiService.getAccommodation(bacc.accommodationId));
        }
      }

      // Fetch Routes
      if (widget.booking.bookedRoutes != null) {
        for (var br in widget.booking.bookedRoutes!) {
          futures.add(ApiService.getRoute(br.routeId));
        }
      }

      final results = await Future.wait(futures);

      int offset = 0;
      if (widget.booking.bookedActivities != null) {
        _activities = results
            .sublist(offset, offset + widget.booking.bookedActivities!.length)
            .cast<TravelActivity>();
        offset += widget.booking.bookedActivities!.length;
      }

      if (widget.booking.bookedAccommodations != null) {
        _accommodations = results
            .sublist(
              offset,
              offset + widget.booking.bookedAccommodations!.length,
            )
            .cast<Accommodation>();
        offset += widget.booking.bookedAccommodations!.length;
      }

      if (widget.booking.bookedRoutes != null) {
        _routes = results
            .sublist(offset, offset + widget.booking.bookedRoutes!.length)
            .cast<TravelRoute>();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Booking #${widget.booking.id}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Booking #${widget.booking.id}')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_errorMessage', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Booking #${widget.booking.id}'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'Overview'),
              Tab(icon: Icon(Icons.route), text: 'Itinerary'),
              Tab(icon: Icon(Icons.receipt), text: 'Expenses'),
              Tab(icon: Icon(Icons.people), text: 'Travelers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            ItineraryBuilderScreen(
              booking: widget.booking,
              activities: _activities,
              accommodations: _accommodations,
              routes: _routes,
            ),
            _buildExpensesTab(),
            _buildTravelersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking Info Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Booking Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      _buildStatusChip(widget.booking.status),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildInfoRow(
                    Icons.account_balance_wallet,
                    'Total Cost',
                    '\$${widget.booking.totalCost.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.payment,
                    'Payment Status',
                    widget.booking.paymentStatus.value.toUpperCase(),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.person,
                    'User ID',
                    widget.booking.userId?.toString() ?? 'Guest',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Summary',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSummaryItem(
            Icons.local_activity,
            'Activities',
            '${_activities.length} items booked',
          ),
          _buildSummaryItem(
            Icons.hotel,
            'Accommodations',
            '${_accommodations.length} items booked',
          ),
          _buildSummaryItem(
            Icons.directions,
            'Routes',
            '${_routes.length} items booked',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    switch (status) {
      case BookingStatus.confirmed:
        color = AppTheme.successColor;
        break;
      case BookingStatus.cancelled:
        color = AppTheme.errorColor;
        break;
      default:
        color = AppTheme.accentColor;
    }
    return Chip(
      label: Text(
        status.value.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildExpensesTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Column(
            children: [
              const Text(
                'Total Booking Cost',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${widget.booking.totalCost.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_activities.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Activities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ..._activities.map(
                  (a) => ListTile(
                    leading: const Icon(
                      Icons.local_activity,
                      color: Colors.blue,
                    ),
                    title: Text(a.name),
                    trailing: Text('\$${a.cost.toStringAsFixed(2)}'),
                  ),
                ),
              ],
              if (_accommodations.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Accommodations',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ..._accommodations.map(
                  (a) => ListTile(
                    leading: const Icon(Icons.hotel, color: Colors.green),
                    title: Text(a.name),
                    trailing: Text('\$${a.cost.toStringAsFixed(2)}'),
                  ),
                ),
              ],
              if (_routes.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Routes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ..._routes.map(
                  (r) => ListTile(
                    leading: const Icon(Icons.directions, color: Colors.orange),
                    title: Text('${r.startLocation} → ${r.endLocation}'),
                    trailing: Text('\$${r.cost.toStringAsFixed(2)}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTravelersTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Traveler information is handled in the trip creator.'),
          const Text('For historical bookings, this data is read-only.'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
