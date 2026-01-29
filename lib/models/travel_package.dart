/// Travel Package model for guest bookings
class TravelPackage {
  final String id;
  final String name;
  final String destination;
  final String description;
  final double price;
  final int duration; // in days
  final String imageUrl; // Main/primary image (for backward compatibility)
  final List<String> imageUrls; // Multiple images for gallery
  final List<String> includedFeatures;
  final bool isPopular;

  TravelPackage({
    required this.id,
    required this.name,
    required this.destination,
    required this.description,
    required this.price,
    required this.duration,
    this.imageUrl = '',
    this.imageUrls = const [],
    this.includedFeatures = const [],
    this.isPopular = false,
  });

  // Get all images (primary + gallery images)
  List<String> get allImages {
    final images = <String>[];
    if (imageUrl.isNotEmpty) {
      images.add(imageUrl);
    }
    images.addAll(imageUrls);
    return images;
  }

  // Get primary image (first from allImages or fallback)
  String get primaryImage {
    return allImages.isNotEmpty ? allImages.first : '';
  }
}
