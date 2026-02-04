import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';
import '../../services/api_service.dart';
import '../../models/travel_route.dart';

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
  List<TravelRoute> _routes = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
    _loadRoutes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final routes = await ApiService.getRoutes(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _routes = routes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  List<TravelRoute> get _filteredRoutes {
    var filtered = List<TravelRoute>.from(_routes);

    // Filter by mode
    if (_selectedMode != 'All') {
      filtered = filtered
          .where(
            (route) =>
                route.travelMode.name.toLowerCase() ==
                _selectedMode.toLowerCase(),
          )
          .toList();
    }

    // Sort
    filtered.sort((a, b) {
      if (_sortBy == 'cost_low') {
        return a.cost.compareTo(b.cost);
      } else if (_sortBy == 'cost_high') {
        return b.cost.compareTo(a.cost);
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
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                                                const Color(
                                                  0xFF1976D2,
                                                ), // Darker blue
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
                                            : AppTheme.primaryColor.withOpacity(
                                                0.4,
                                              ),
                                        width: 2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppTheme.primaryColor
                                                    .withOpacity(0.5),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: FilterChip(
                                        label: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: Text(
                                            mode,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppTheme.textPrimary,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
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
                              })
                              .toList(),
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    )
                  : _errorMessage != null
                  ? Center(
                      child: AnimatedGlassCard(
                        delay: const Duration(milliseconds: 300),
                        blur: 10.0,
                        opacity: 0.2,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: AppTheme.errorColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppTheme.errorColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.errorColor,
                                      AppTheme.errorColor.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.errorColor.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _loadRoutes,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : _filteredRoutes.isEmpty
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
                                                _getModeIcon(route.travelMode),
                                                color: AppTheme.primaryColor,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                route.travelMode.name
                                                    .toUpperCase(),
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
                                                route.startLocation,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  size: 16,
                                                  color: AppTheme.textSecondary,
                                                ),
                                              ),
                                              Text(
                                                route.endLocation,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$${route.cost.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  route.description,
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Divider(
                                  color: AppTheme.textSecondary.withOpacity(
                                    0.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      route.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Add route to trip
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
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

  IconData _getModeIcon(TravelMode mode) {
    switch (mode) {
      case TravelMode.flight:
        return Icons.flight;
      case TravelMode.train:
        return Icons.train;
      case TravelMode.bus:
        return Icons.directions_bus;
      case TravelMode.car:
        return Icons.directions_car;
      case TravelMode.walking:
        return Icons.directions_walk;
      default:
        return Icons.route;
    }
  }
}
