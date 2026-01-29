import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/trip.dart';
import '../../common_widgets/glassmorphism.dart';
import 'trip_detail_screen.dart';

/// Trip History Screen - View all past trips
class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  // Mock trip history data
  final List<Trip> _tripHistory = [
    Trip(
      id: '1',
      name: 'Summer in Paris',
      destination: 'Paris, France',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: DateTime.now().subtract(const Duration(days: 83)),
      type: 'Group',
      travelers: ['User1', 'User2', 'User3'],
      budget: 5000,
      description: 'Amazing trip to the City of Light',
      createdBy: 'User1',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Trip(
      id: '2',
      name: 'Tokyo Adventure',
      destination: 'Tokyo, Japan',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 53)),
      type: 'Solo',
      travelers: ['User1'],
      budget: 3000,
      description: 'Solo exploration of Japanese culture',
      createdBy: 'User1',
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
    ),
    Trip(
      id: '3',
      name: 'Bali Paradise',
      destination: 'Bali, Indonesia',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().subtract(const Duration(days: 24)),
      type: 'Family',
      travelers: ['User1', 'Spouse', 'Child1'],
      budget: 4000,
      description: 'Family vacation in tropical paradise',
      createdBy: 'User1',
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
  ];

  String _filterType = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredTrips = _filterType == 'All'
        ? _tripHistory
        : _tripHistory.where((trip) => trip.type == _filterType).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.secondaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom App Bar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.secondaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Trip History',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            ),
            // Filter Section with glassmorphism
            AnimatedGlassCard(
              delay: const Duration(milliseconds: 100),
              blur: 8.0,
              opacity: 0.15,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                ),
            child: Row(
              children: [
                const Text(
                  'Filter by Type:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Solo', 'Group', 'Business', 'Family']
                          .map((type) {
                        final isSelected = _filterType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        const Color(0xFF1976D2), // Darker blue
                                        AppTheme.primaryColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.95),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppTheme.primaryColor.withOpacity(0.4),
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryColor.withOpacity(0.5),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: FilterChip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.textPrimary,
                                      fontWeight:
                                          isSelected ? FontWeight.bold : FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _filterType = type;
                                  });
                                },
                                selectedColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                checkmarkColor: Colors.white,
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                                labelPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
              ),
            ),
            // Trips List
            Expanded(
              child: filteredTrips.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No trips found',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your trip history will appear here',
                            style: TextStyle(
                              color: AppTheme.textSecondary.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTrips.length,
                      itemBuilder: (context, index) {
                        final trip = filteredTrips[index];
                        return AnimatedGlassCard(
                          delay: Duration(milliseconds: 150 + (index * 50)),
                          blur: 8.0,
                          opacity: 0.15,
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripDetailScreen(trip: trip),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.7),
                                ],
                              ),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            trip.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: AppTheme.textSecondary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                trip.destination,
                                                style: TextStyle(
                                                  color: AppTheme.textSecondary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
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
                                        color: _getTypeColor(trip.type)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _getTypeColor(trip.type)
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        trip.type,
                                        style: TextStyle(
                                          color: _getTypeColor(trip.type),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (trip.description != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    trip.description!,
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildInfoChip(
                                      icon: Icons.calendar_today,
                                      label:
                                          '${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year}',
                                    ),
                                    const SizedBox(width: 12),
                                    _buildInfoChip(
                                      icon: Icons.access_time,
                                      label: '${trip.duration} days',
                                    ),
                                    if (trip.budget != null) ...[
                                      const SizedBox(width: 12),
                                      _buildInfoChip(
                                        icon: Icons.account_balance_wallet,
                                        label: '\$${trip.budget!.toStringAsFixed(0)}',
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 16,
                                          color: AppTheme.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${trip.travelers.length} traveler${trip.travelers.length > 1 ? 's' : ''}',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TripDetailScreen(trip: trip),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text('View Details'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'solo':
        return Colors.blue;
      case 'group':
        return Colors.green;
      case 'business':
        return Colors.orange;
      case 'family':
        return Colors.purple;
      default:
        return AppTheme.primaryColor;
    }
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
