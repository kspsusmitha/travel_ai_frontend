import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/booking.dart';
import '../../models/travel_activity.dart';
import '../../models/accommodation.dart';
import '../../models/travel_route.dart';

class ItineraryBuilderScreen extends StatelessWidget {
  final Booking booking;
  final List<TravelActivity> activities;
  final List<Accommodation> accommodations;
  final List<TravelRoute> routes;

  const ItineraryBuilderScreen({
    super.key,
    required this.booking,
    required this.activities,
    required this.accommodations,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty && accommodations.isEmpty && routes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No items booked in this itinerary.'),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (accommodations.isNotEmpty) ...[
          _buildSectionHeader('Accommodations', Icons.hotel),
          ...accommodations.map((acc) => _buildAccommodationCard(acc)),
          const SizedBox(height: 16),
        ],
        if (activities.isNotEmpty) ...[
          _buildSectionHeader('Activities', Icons.local_activity),
          ...activities.map((act) => _buildActivityCard(act)),
          const SizedBox(height: 16),
        ],
        if (routes.isNotEmpty) ...[
          _buildSectionHeader('Travel Routes', Icons.directions),
          ...routes.map((route) => _buildRouteCard(route)),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(TravelActivity activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          child: const Icon(Icons.local_activity, color: Colors.blue),
        ),
        title: Text(
          activity.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.location),
            if (activity.startTime != null)
              Text(
                'Time: ${DateFormat('MMM dd, hh:mm a').format(activity.startTime!)}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: Text(
          '\$${activity.cost.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.successColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAccommodationCard(Accommodation acc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          child: const Icon(Icons.hotel, color: Colors.green),
        ),
        title: Text(
          acc.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(acc.location),
            Text(
              'Check-in: ${acc.checkIn} | Check-out: ${acc.checkOut}',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
        trailing: Text(
          '\$${acc.cost.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.successColor,
          ),
        ),
      ),
    );
  }

  Widget _buildRouteCard(TravelRoute route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
          child: const Icon(Icons.directions, color: Colors.orange),
        ),
        title: Text(
          '${route.startLocation} → ${route.endLocation}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Mode: ${route.travelMode.value}'),
        trailing: Text(
          '\$${route.cost.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.successColor,
          ),
        ),
      ),
    );
  }
}

