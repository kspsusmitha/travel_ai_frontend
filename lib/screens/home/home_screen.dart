import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../models/trip.dart';
import '../trip/create_trip_screen.dart';
import '../trip/trip_detail_screen.dart';
import '../accommodation/accommodation_finder_screen.dart';
import '../activity/activity_finder_screen.dart';
import '../ai/ai_suggestions_screen.dart';
import '../nearby/nearby_essentials_screen.dart';
import '../budget/budget_planner_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Mock data - will be replaced with API calls
  final List<Trip> _trips = [
    Trip(
      id: '1',
      name: 'Summer in Paris',
      destination: 'Paris, France',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 37)),
      type: AppConstants.tripTypeGroup,
      travelers: ['User1', 'User2', 'User3'],
      budget: 5000,
      createdBy: 'User1',
      createdAt: DateTime.now(),
    ),
    Trip(
      id: '2',
      name: 'Tokyo Adventure',
      destination: 'Tokyo, Japan',
      startDate: DateTime.now().add(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 67)),
      type: AppConstants.tripTypeSolo,
      travelers: ['User1'],
      budget: 3000,
      createdBy: 'User1',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: _getBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTripScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Nearby',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildExploreTab();
      case 2:
        return BudgetPlannerScreen();
      case 3:
        return const NearbyEssentialsScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'Create Trip',
                  color: AppTheme.primaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateTripScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.auto_awesome,
                  title: 'AI Suggestions',
                  color: AppTheme.accentColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AISuggestionsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.hotel,
                  title: 'Find Hotels',
                  color: AppTheme.secondaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccommodationFinderScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.local_activity,
                  title: 'Activities',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActivityFinderScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // My Trips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Trips',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Show all trips
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_trips.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No trips yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first trip to get started!',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            )
          else
            ..._trips.map((trip) => _buildTripCard(trip)),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _buildFeatureCard(
            icon: Icons.hotel,
            title: 'Accommodation Finder',
            description: 'Find hotels, Airbnb, and hostels',
            color: AppTheme.secondaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccommodationFinderScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: Icons.local_activity,
            title: 'Activity Finder',
            description: 'Discover tours, adventures, and local experiences',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityFinderScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: Icons.auto_awesome,
            title: 'AI Suggestions',
            description: 'Get personalized trip recommendations',
            color: AppTheme.accentColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AISuggestionsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: Icons.location_on,
            title: 'Nearby Essentials',
            description: 'Find ATMs, hospitals, restaurants, and more',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbyEssentialsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetailScreen(trip: trip),
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
                    child: Text(
                      trip.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(trip.type),
                    backgroundColor: trip.type == AppConstants.tripTypeGroup
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    trip.destination,
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year} - ${trip.endDate.day}/${trip.endDate.month}/${trip.endDate.year}',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.people, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${trip.travelers.length} ${trip.travelers.length == 1 ? 'traveler' : 'travelers'}',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              if (trip.budget != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Budget: \$${trip.budget!.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
