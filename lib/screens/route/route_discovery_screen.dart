import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';

/// Route Discovery Screen - View and filter travel routes
class RouteDiscoveryScreen extends StatefulWidget {
  const RouteDiscoveryScreen({super.key});

  @override
  State<RouteDiscoveryScreen> createState() => _RouteDiscoveryScreenState();
}

class _RouteDiscoveryScreenState extends State<RouteDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _selectedMode = 'All';
  String _sortBy = 'cost_low';
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  // Mock route data
  final List<Map<String, dynamic>> _routes = [
    {
      'id': '1',
      'from': 'New York',
      'to': 'Paris',
      'mode': 'Flight',
      'duration': '7h 30m',
      'cost': 850.00,
      'airline': 'Air France',
      'departure': '08:00 AM',
      'arrival': '09:30 PM',
    },
    {
      'id': '2',
      'from': 'New York',
      'to': 'Paris',
      'mode': 'Flight',
      'duration': '8h 15m',
      'cost': 720.00,
      'airline': 'Delta Airlines',
      'departure': '10:30 PM',
      'arrival': '12:45 PM',
    },
    {
      'id': '3',
      'from': 'Tokyo',
      'to': 'Bali',
      'mode': 'Flight',
      'duration': '6h 45m',
      'cost': 450.00,
      'airline': 'Garuda Indonesia',
      'departure': '02:00 PM',
      'arrival': '08:45 PM',
    },
    {
      'id': '4',
      'from': 'London',
      'to': 'Paris',
      'mode': 'Train',
      'duration': '2h 20m',
      'cost': 120.00,
      'airline': 'Eurostar',
      'departure': '09:00 AM',
      'arrival': '11:20 AM',
    },
    {
      'id': '5',
      'from': 'Paris',
      'to': 'Brussels',
      'mode': 'Bus',
      'duration': '3h 30m',
      'cost': 35.00,
      'airline': 'FlixBus',
      'departure': '08:00 AM',
      'arrival': '11:30 AM',
    },
  ];

  List<Map<String, dynamic>> get _filteredRoutes {
    var filtered = List<Map<String, dynamic>>.from(_routes);

    // Filter by mode
    if (_selectedMode != 'All') {
      filtered = filtered
          .where((route) => route['mode'] == _selectedMode)
          .toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      filtered = filtered.where((route) {
        return route['from'].toString().toLowerCase().contains(searchLower) ||
            route['to'].toString().toLowerCase().contains(searchLower);
      }).toList();
    }

    // Sort
    filtered.sort((a, b) {
      if (_sortBy == 'cost_low') {
        return (a['cost'] as double).compareTo(b['cost'] as double);
      } else if (_sortBy == 'cost_high') {
        return (b['cost'] as double).compareTo(a['cost'] as double);
      } else if (_sortBy == 'duration') {
        return a['duration'].toString().compareTo(b['duration'].toString());
      }
      return 0;
    });

    return filtered;
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
                    'Route Discovery',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            ),
            // Search Bar with glassmorphism
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by origin or destination...',
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            // Filters with glassmorphism
            AnimatedGlassCard(
              delay: const Duration(milliseconds: 150),
              blur: 8.0,
              opacity: 0.15,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.all(16),
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
                      'Mode:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Flight', 'Train', 'Bus', 'Car']
                              .map((mode) {
                            final isSelected = _selectedMode == mode;
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
                                        mode,
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
                                        _selectedMode = mode;
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
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _sortBy,
                      items: const [
                        DropdownMenuItem(
                          value: 'cost_low',
                          child: Text('Price: Low to High'),
                        ),
                        DropdownMenuItem(
                          value: 'cost_high',
                          child: Text('Price: High to Low'),
                        ),
                        DropdownMenuItem(
                          value: 'duration',
                          child: Text('Duration'),
                        ),
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
            ),
            const SizedBox(height: 8),
            // Routes List
            Expanded(
              child: _filteredRoutes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.route,
                            size: 64,
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No routes found',
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
                      itemCount: _filteredRoutes.length,
                      itemBuilder: (context, index) {
                        final route = _filteredRoutes[index];
                        return AnimatedGlassCard(
                          delay: Duration(milliseconds: 200 + (index * 50)),
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
                                        Row(
                                          children: [
                                            Icon(
                                              _getModeIcon(route['mode']),
                                              color: AppTheme.primaryColor,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              route['mode'],
                                              style: TextStyle(
                                                color: AppTheme.primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              route['from'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                size: 16,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                            Text(
                                              route['to'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${route['cost'].toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        route['duration'],
                                        style: TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: AppTheme.textSecondary.withOpacity(0.2),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        route['airline'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            size: 14,
                                            color: AppTheme.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${route['departure']} - ${route['arrival']}',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: Add route to trip
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Route added to trip planning',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Select Route'),
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

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'Flight':
        return Icons.flight;
      case 'Train':
        return Icons.train;
      case 'Bus':
        return Icons.directions_bus;
      case 'Car':
        return Icons.directions_car;
      default:
        return Icons.route;
    }
  }
}
