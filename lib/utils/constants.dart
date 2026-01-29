class AppConstants {
  static const String appName = 'TripMate';
  static const String appTagline = 'Your Smart Travel Buddy';
  
  // API endpoints
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiPrefix = '/api/';
  
  // Trip types
  static const String tripTypeSolo = 'Solo';
  static const String tripTypeGroup = 'Group';
  
  // Expense categories
  static const List<String> expenseCategories = [
    'Accommodation',
    'Food',
    'Transport',
    'Activities',
    'Shopping',
    'Emergency',
    'Other',
  ];
  
  // Nearby essentials categories
  static const List<String> nearbyCategories = [
    'ATM',
    'Hospital',
    'Restaurant',
    'Police Station',
    'Gas Station',
    'Pharmacy',
    'Bank',
    'Tourist Info',
  ];
  
  // Activity types
  static const List<String> activityTypes = [
    'Adventure',
    'Cultural',
    'Relaxation',
    'Food & Drink',
    'Nightlife',
    'Shopping',
    'Nature',
    'Historical',
  ];
}
