import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../common_widgets/glassmorphism.dart';

class NearbyEssentialsScreen extends StatefulWidget {
  const NearbyEssentialsScreen({super.key});

  @override
  State<NearbyEssentialsScreen> createState() => _NearbyEssentialsScreenState();
}

class _NearbyEssentialsScreenState extends State<NearbyEssentialsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                    'Nearby Essentials',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            ),
            // Location Search with glassmorphism
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
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            // Category Selection with glassmorphism
            AnimatedGlassCard(
              delay: const Duration(milliseconds: 150),
              blur: 8.0,
              opacity: 0.15,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                ),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: AppConstants.nearbyCategories.length,
                    itemBuilder: (context, index) {
                      final category = AppConstants.nearbyCategories[index];
                      return _buildCategoryCard(category, index);
                    },
                  ),
                ),
              ),
            ),
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
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${_selectedCategory.toLowerCase()}s found nearby',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _currentPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _currentPlaces[index];
                        return _buildPlaceCard(place, index);
                      },
                    ),
            ),
          ],
        ),
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

  Widget _buildCategoryCard(String category, int index) {
    final isSelected = _selectedCategory == category;
    return AnimatedGlassCard(
      delay: Duration(milliseconds: 200 + (index * 50)),
      blur: isSelected ? 10.0 : 5.0,
      opacity: isSelected ? 0.2 : 0.1,
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.secondaryColor,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppTheme.primaryColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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

  Widget _buildPlaceCard(Map<String, dynamic> place, int index) {
    return AnimatedGlassCard(
      delay: Duration(milliseconds: 250 + (index * 100)),
      blur: 8.0,
      opacity: 0.15,
      borderRadius: BorderRadius.circular(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.secondaryColor,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                _getCategoryIcon(_selectedCategory),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place['address'],
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  if (place['distance'] != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        place['distance'],
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                  if (place['rating'] != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${place['rating']}',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (place['phone'] != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.green.shade700,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed: () {
                        // TODO: Make phone call
                      },
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.directions, color: Colors.white),
                    onPressed: () {
                      // TODO: Get directions
                    },
                  ),
                ),
              ],
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
