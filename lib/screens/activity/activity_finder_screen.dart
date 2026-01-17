import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../models/activity.dart';

class ActivityFinderScreen extends StatefulWidget {
  const ActivityFinderScreen({super.key});

  @override
  State<ActivityFinderScreen> createState() => _ActivityFinderScreenState();
}

class _ActivityFinderScreenState extends State<ActivityFinderScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _sortBy = 'rating';

  // Mock activities data
  final List<Activity> _activities = [
    Activity(
      id: '1',
      name: 'Eiffel Tower Tour',
      type: 'Cultural',
      location: 'Paris, France',
      price: 25,
      rating: 4.7,
      description: 'Guided tour of the iconic Eiffel Tower',
      duration: 120,
    ),
    Activity(
      id: '2',
      name: 'Seine River Cruise',
      type: 'Relaxation',
      location: 'Paris, France',
      price: 30,
      rating: 4.5,
      description: 'Scenic boat cruise along the Seine River',
      duration: 90,
    ),
    Activity(
      id: '3',
      name: 'Bungee Jumping',
      type: 'Adventure',
      location: 'Paris, France',
      price: 80,
      rating: 4.9,
      description: 'Thrilling bungee jumping experience',
      duration: 60,
    ),
  ];

  List<Activity> get _filteredActivities {
    var filtered = _activities;
    
    if (_selectedCategory != 'all') {
      filtered = filtered.where((a) => a.type == _selectedCategory).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((a) =>
          a.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          a.location.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    if (_sortBy == 'rating') {
      filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    } else if (_sortBy == 'price_low') {
      filtered.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (_sortBy == 'price_high') {
      filtered.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    }
    
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Activities'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // Category Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                _buildCategoryChip('All', 'all'),
                ...AppConstants.activityTypes.map(
                  (type) => _buildCategoryChip(type, type),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Sort Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Sort by: '),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'rating', child: Text('Rating')),
                    DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                    DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          // Activities List
          Expanded(
            child: _filteredActivities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_activity,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No activities found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _filteredActivities[index];
                      return _buildActivityCard(activity);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _selectedCategory == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _getTypeColor(activity.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(activity.type),
                    color: _getTypeColor(activity.type),
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              activity.location,
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(activity.type),
                        backgroundColor: _getTypeColor(activity.type).withOpacity(0.1),
                        labelStyle: TextStyle(color: _getTypeColor(activity.type)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (activity.description != null) ...[
              const SizedBox(height: 12),
              Text(
                activity.description!,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (activity.rating != null) ...[
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${activity.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                ],
                if (activity.duration != null) ...[
                  Icon(Icons.timer, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${activity.duration} min',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (activity.price != null)
                  Text(
                    '\$${activity.price!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Open in Google Maps
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Map'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Add to itinerary
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${activity.name} added to itinerary'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'adventure':
        return Icons.terrain;
      case 'cultural':
        return Icons.museum;
      case 'relaxation':
        return Icons.spa;
      case 'food & drink':
        return Icons.restaurant;
      case 'nightlife':
        return Icons.nightlife;
      case 'shopping':
        return Icons.shopping_bag;
      case 'nature':
        return Icons.nature;
      case 'historical':
        return Icons.history;
      default:
        return Icons.local_activity;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'adventure':
        return Colors.red;
      case 'cultural':
        return Colors.blue;
      case 'relaxation':
        return Colors.green;
      case 'food & drink':
        return Colors.orange;
      case 'nightlife':
        return Colors.purple;
      case 'shopping':
        return Colors.pink;
      case 'nature':
        return Colors.teal;
      case 'historical':
        return Colors.brown;
      default:
        return AppTheme.primaryColor;
    }
  }
}
