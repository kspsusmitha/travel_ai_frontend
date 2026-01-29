import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/travel_package.dart';
import '../../common_widgets/glassmorphism.dart';
import '../auth/user_selection_screen.dart';
import 'guest_ai_preview_screen.dart';
import 'guest_package_details_screen.dart';

/// Guest Landing Screen - Travel Packages & Destinations (read-only)
class GuestLandingScreen extends StatefulWidget {
  const GuestLandingScreen({super.key});

  @override
  State<GuestLandingScreen> createState() => _GuestLandingScreenState();
}

class _GuestLandingScreenState extends State<GuestLandingScreen> {

  // Dummy travel packages data
  static final List<TravelPackage> _travelPackages = [
    TravelPackage(
      id: '1',
      name: 'Paris City Break',
      destination: 'Paris, France',
      description: 'Explore the City of Light with guided tours of Eiffel Tower, Louvre Museum, and Seine River cruise',
      price: 899.00,
      duration: 5,
      imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80',
        'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=800&q=80',
        'https://images.unsplash.com/photo-1549144511-f099e773c147?w=800&q=80',
      ],
      includedFeatures: ['Hotel accommodation', 'Breakfast included', 'City tour', 'Museum tickets'],
      isPopular: true,
    ),
    TravelPackage(
      id: '2',
      name: 'Tokyo Adventure',
      destination: 'Tokyo, Japan',
      description: 'Experience Japanese culture with visits to temples, markets, and authentic dining experiences',
      price: 1299.00,
      duration: 7,
      imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800&q=80',
        'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&q=80',
        'https://images.unsplash.com/photo-1528164344705-47542687000d?w=800&q=80',
      ],
      includedFeatures: ['4-star hotel', 'Daily breakfast', 'JR Pass', 'Cultural experiences'],
      isPopular: true,
    ),
    TravelPackage(
      id: '3',
      name: 'Bali Paradise',
      destination: 'Bali, Indonesia',
      description: 'Relax on beautiful beaches, visit ancient temples, and enjoy spa treatments',
      price: 699.00,
      duration: 6,
      imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800&q=80',
        'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800&q=80',
        'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
      ],
      includedFeatures: ['Beachfront resort', 'Airport transfers', 'Spa session', 'Temple tours'],
      isPopular: false,
    ),
    TravelPackage(
      id: '4',
      name: 'New York Explorer',
      destination: 'New York, USA',
      description: 'Discover the Big Apple with Broadway shows, Statue of Liberty, and Central Park tours',
      price: 1099.00,
      duration: 5,
      imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800&q=80',
        'https://images.unsplash.com/photo-1500916434205-0c77489c6cf7?w=800&q=80',
        'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800&q=80',
      ],
      includedFeatures: ['Manhattan hotel', 'Broadway tickets', 'City pass', 'Food tour'],
      isPopular: false,
    ),
    TravelPackage(
      id: '5',
      name: 'Dubai Luxury',
      destination: 'Dubai, UAE',
      description: 'Experience luxury shopping, desert safaris, and iconic landmarks',
      price: 1499.00,
      duration: 4,
      imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&q=80',
      imageUrls: [
        'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&q=80',
        'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&q=80',
        'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80',
      ],
      includedFeatures: ['5-star hotel', 'Desert safari', 'Burj Khalifa tickets', 'Shopping vouchers'],
      isPopular: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.9),
              AppTheme.secondaryColor.withOpacity(0.8),
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // App Bar with glassmorphism
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.9),
                        AppTheme.secondaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=1920&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.primaryColor.withOpacity(0.5),
                              );
                            },
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.flight_takeoff,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Plan Your Dream Trip',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Browse travel packages and preview AI trip planning',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserSelectionScreen(),
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  tooltip: 'AI Trip Planner Preview',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GuestAIPreviewScreen(),
                      ),
                    );
                  },
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            // Travel Packages List
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final package = _travelPackages[index];
                    return AnimatedGlassCard(
                      delay: Duration(milliseconds: 100 * index),
                      blur: 5.0,
                      opacity: 0.15,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: package.isPopular
                              ? Border.all(
                                  color: AppTheme.accentColor.withOpacity(0.5),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Destination Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Network Image with fallback
                                    package.primaryImage.isNotEmpty
                                        ? Image.network(
                                            package.primaryImage,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppTheme.primaryColor
                                                          .withOpacity(0.6),
                                                      AppTheme.secondaryColor
                                                          .withOpacity(0.6),
                                                    ],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppTheme.primaryColor
                                                          .withOpacity(0.6),
                                                      AppTheme.secondaryColor
                                                          .withOpacity(0.6),
                                                    ],
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.landscape,
                                                  size: 64,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppTheme.primaryColor
                                                      .withOpacity(0.6),
                                                  AppTheme.secondaryColor
                                                      .withOpacity(0.6),
                                                ],
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.landscape,
                                              size: 64,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                    // Gradient overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.4),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (package.isPopular)
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.accentColor,
                                                AppTheme.accentColor
                                                    .withOpacity(0.8),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            'POPULAR',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            // Content
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withOpacity(0.95),
                                    Colors.white.withOpacity(0.9),
                                  ],
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
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
                                              package.name,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 18,
                                                  color: AppTheme.primaryColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  package.destination,
                                                  style: TextStyle(
                                                    color: AppTheme.textSecondary,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    package.description,
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      height: 1.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  // Features
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        package.includedFeatures.map((feature) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme.primaryColor
                                                  .withOpacity(0.15),
                                              AppTheme.primaryColor
                                                  .withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          feature,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\$${package.price.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            '${package.duration} days',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme.primaryColor,
                                              AppTheme.secondaryColor,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GuestPackageDetailsScreen(
                                                  package: package,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.info_outline,
                                              color: Colors.white),
                                          label: const Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _travelPackages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
