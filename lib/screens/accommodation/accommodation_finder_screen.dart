import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/accommodation.dart';

class AccommodationFinderScreen extends StatefulWidget {
  const AccommodationFinderScreen({super.key});

  @override
  State<AccommodationFinderScreen> createState() => _AccommodationFinderScreenState();
}

class _AccommodationFinderScreenState extends State<AccommodationFinderScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _sortBy = 'rating';

  // Mock accommodations data
  final List<Accommodation> _accommodations = [
    Accommodation(
      id: '1',
      name: 'Grand Hotel Paris',
      type: 'hotel',
      location: 'Paris, France',
      pricePerNight: 150,
      rating: 4.5,
      description: 'Luxury hotel in the heart of Paris',
      amenities: {'wifi': true, 'pool': true, 'spa': true},
    ),
    Accommodation(
      id: '2',
      name: 'Cozy Airbnb Downtown',
      type: 'airbnb',
      location: 'Paris, France',
      pricePerNight: 80,
      rating: 4.8,
      description: 'Beautiful apartment near city center',
      amenities: {'wifi': true, 'kitchen': true},
    ),
  ];

  List<Accommodation> get _filteredAccommodations {
    var filtered = _accommodations;
    
    if (_selectedFilter != 'all') {
      filtered = filtered.where((a) => a.type == _selectedFilter).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((a) =>
          a.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          a.location.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    if (_sortBy == 'rating') {
      filtered.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    } else if (_sortBy == 'price_low') {
      filtered.sort((a, b) => (a.pricePerNight ?? 0).compareTo(b.pricePerNight ?? 0));
    } else if (_sortBy == 'price_high') {
      filtered.sort((a, b) => (b.pricePerNight ?? 0).compareTo(a.pricePerNight ?? 0));
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
        title: const Text('Find Accommodation'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or location...',
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
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Hotels', 'hotel'),
                const SizedBox(width: 8),
                _buildFilterChip('Airbnb', 'airbnb'),
                const SizedBox(width: 8),
                _buildFilterChip('Hostels', 'hostel'),
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
          // Accommodations List
          Expanded(
            child: _filteredAccommodations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hotel,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No accommodations found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAccommodations.length,
                    itemBuilder: (context, index) {
                      final accommodation = _filteredAccommodations[index];
                      return _buildAccommodationCard(accommodation);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }

  Widget _buildAccommodationCard(Accommodation accommodation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Icon(
              Icons.hotel,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        accommodation.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(accommodation.type.toUpperCase()),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        accommodation.location,
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                if (accommodation.rating != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${accommodation.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
                if (accommodation.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    accommodation.description!,
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
                if (accommodation.pricePerNight != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${accommodation.pricePerNight!.toStringAsFixed(0)}/night',
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
                                  content: Text('${accommodation.name} added to itinerary'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
