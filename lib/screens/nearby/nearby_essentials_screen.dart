import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class NearbyEssentialsScreen extends StatefulWidget {
  const NearbyEssentialsScreen({super.key});

  @override
  State<NearbyEssentialsScreen> createState() => _NearbyEssentialsScreenState();
}

class _NearbyEssentialsScreenState extends State<NearbyEssentialsScreen> {
  String _selectedCategory = AppConstants.nearbyCategories[0];
  final _locationController = TextEditingController();
  bool _sosEnabled = false;

  // Mock nearby places data
  final Map<String, List<Map<String, dynamic>>> _nearbyPlaces = {
    'ATM': [
      {'name': 'Bank of America ATM', 'distance': '0.2 km', 'address': '123 Main St'},
      {'name': 'Chase ATM', 'distance': '0.5 km', 'address': '456 Oak Ave'},
    ],
    'Hospital': [
      {'name': 'City General Hospital', 'distance': '1.2 km', 'address': '789 Health Blvd', 'phone': '+1-234-567-8900'},
    ],
    'Restaurant': [
      {'name': 'La Belle Cuisine', 'distance': '0.3 km', 'address': '321 Food St', 'rating': 4.5},
      {'name': 'The Local Bistro', 'distance': '0.7 km', 'address': '654 Taste Ave', 'rating': 4.2},
    ],
    'Police Station': [
      {'name': 'Central Police Station', 'distance': '0.8 km', 'address': '987 Safety Rd', 'phone': '911'},
    ],
  };

  List<Map<String, dynamic>> get _currentPlaces {
    return _nearbyPlaces[_selectedCategory] ?? [];
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _callEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency SOS'),
        content: const Text('Calling emergency services...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement emergency call
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency services called'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Call 911'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Essentials'),
      ),
      body: Column(
        children: [
          // Location Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Enter location or use current',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: () {
                    // TODO: Get current location
                    _locationController.text = 'Current Location';
                  },
                ),
              ),
            ),
          ),
          // Category Selection
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.nearbyCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.nearbyCategories[index];
                return _buildCategoryCard(category);
              },
            ),
          ),
          const Divider(),
          // Places List
          Expanded(
            child: _currentPlaces.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(_selectedCategory),
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No ${_selectedCategory.toLowerCase()}s found nearby',
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _currentPlaces[index];
                      return _buildPlaceCard(place);
                    },
                  ),
          ),
        ],
      ),
      // Emergency SOS Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sosEnabled ? _callEmergency : null,
        backgroundColor: _sosEnabled ? AppTheme.errorColor : Colors.grey,
        icon: const Icon(Icons.warning),
        label: const Text('SOS'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('Enable Emergency SOS'),
            const Spacer(),
            Switch(
              value: _sosEnabled,
              onChanged: (value) {
                setState(() {
                  _sosEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String category) {
    final isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: isSelected ? Colors.white : AppTheme.primaryColor,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            _getCategoryIcon(_selectedCategory),
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(place['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place['address']),
            if (place['distance'] != null)
              Text(
                place['distance'],
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (place['rating'] != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text('${place['rating']}'),
                ],
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (place['phone'] != null)
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  // TODO: Make phone call
                },
              ),
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                // TODO: Open in Google Maps
              },
            ),
            IconButton(
              icon: const Icon(Icons.directions),
              onPressed: () {
                // TODO: Get directions
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ATM':
        return Icons.atm;
      case 'Hospital':
        return Icons.local_hospital;
      case 'Restaurant':
        return Icons.restaurant;
      case 'Police Station':
        return Icons.local_police;
      case 'Gas Station':
        return Icons.local_gas_station;
      case 'Pharmacy':
        return Icons.local_pharmacy;
      case 'Bank':
        return Icons.account_balance;
      case 'Tourist Info':
        return Icons.info;
      default:
        return Icons.place;
    }
  }
}
