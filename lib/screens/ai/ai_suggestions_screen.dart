import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../../common_widgets/glassmorphism.dart';

class AISuggestionsScreen extends StatefulWidget {
  const AISuggestionsScreen({super.key});

  @override
  State<AISuggestionsScreen> createState() => _AISuggestionsScreenState();
}

class _AISuggestionsScreenState extends State<AISuggestionsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _destinationController = TextEditingController();
  final _durationController = TextEditingController();
  final _budgetController = TextEditingController();
  String _selectedSuggestionType = 'day_plan';
  UserType? _selectedTravelerType;
  bool _isLoading = false;
  String? _aiResponseText;
  String? _errorMessage;

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
    _destinationController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _getSuggestions() async {
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a destination'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_selectedSuggestionType == 'day_plan' || _selectedSuggestionType == 'budget') {
      if (_durationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter number of days'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
    }

    if (_budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your budget'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_selectedTravelerType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a traveler type'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _aiResponseText = null;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Implement API call with:
    // - Destination: _destinationController.text
    // - Days: int.parse(_durationController.text)
    // - Budget: double.parse(_budgetController.text)
    // - Traveler Type: _selectedTravelerType
    
    setState(() {
      _aiResponseText = _buildMockResponse();
      _isLoading = false;
    });
  }

  String _buildMockResponse() {
    final travelerType = _selectedTravelerType!.displayName;
    final destination = _destinationController.text;
    final days = _durationController.text.isEmpty ? '7' : _durationController.text;
    final budget = _budgetController.text;
    
    if (_selectedSuggestionType == 'day_plan') {
      return '''
Optimized ${days}-Day Itinerary for $destination
Traveler Type: $travelerType

Day 1: Arrival & City Exploration
- Morning: Check-in at recommended hotel
- Afternoon: City center walking tour
- Evening: Local cuisine experience

Day 2: Main Attractions
- Morning: Visit top landmarks
- Afternoon: Museum or cultural site
- Evening: Relaxation time

Budget Distribution:
- Accommodation: \$${(double.parse(budget) * 0.4).toStringAsFixed(0)}
- Activities: \$${(double.parse(budget) * 0.3).toStringAsFixed(0)}
- Food: \$${(double.parse(budget) * 0.2).toStringAsFixed(0)}
- Transportation: \$${(double.parse(budget) * 0.1).toStringAsFixed(0)}

Note: This is a sample itinerary. Full AI-powered suggestions will be available after API integration.
''';
    } else if (_selectedSuggestionType == 'budget') {
      return '''
Budget Breakdown for $destination
Traveler Type: $travelerType
Total Budget: \$$budget

Recommended Allocation:
- Accommodation (40%): \$${(double.parse(budget) * 0.4).toStringAsFixed(0)}
- Activities & Tours (30%): \$${(double.parse(budget) * 0.3).toStringAsFixed(0)}
- Food & Dining (20%): \$${(double.parse(budget) * 0.2).toStringAsFixed(0)}
- Transportation (10%): \$${(double.parse(budget) * 0.1).toStringAsFixed(0)}

Daily Budget: \$${(double.parse(budget) / (days.isEmpty ? 7 : int.parse(days))).toStringAsFixed(0)} per day

Note: Budget allocation optimized for $travelerType preferences.
''';
    } else {
      return '''
Best Time to Visit $destination

Recommended Seasons:
- Spring (March-May): Mild weather, fewer crowds
- Fall (September-November): Pleasant temperatures, good for outdoor activities

Traveler Type Considerations for $travelerType:
- Optimal travel periods based on your preferences
- Weather conditions suitable for your travel style

Note: Full AI-powered recommendations will be available after API integration.
''';
    }
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
                    'AI Trip Planning',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card with glassmorphism
                    AnimatedGlassCard(
                      delay: const Duration(milliseconds: 100),
                      blur: 10.0,
                      opacity: 0.2,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              AppTheme.accentColor.withOpacity(0.05),
                            ],
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
                                    AppTheme.accentColor,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'AI-Powered Suggestions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Get personalized recommendations for your trip',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Suggestion Type Selection with glassmorphism
                    AnimatedGlassCard(
                      delay: const Duration(milliseconds: 200),
                      blur: 8.0,
                      opacity: 0.15,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What would you like suggestions for?',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildSuggestionTypeChip('Best Time to Visit', 'best_time'),
                                _buildSuggestionTypeChip('Day-wise Plan', 'day_plan'),
                                _buildSuggestionTypeChip('Budget Breakdown', 'budget'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Traveler Type Selection with glassmorphism
                    AnimatedGlassCard(
                      delay: const Duration(milliseconds: 250),
                      blur: 8.0,
                      opacity: 0.15,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Traveler Type',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: UserType.values.map((type) {
                                final isSelected = _selectedTravelerType == type;
                                return Container(
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
                                      avatar: Icon(
                                        type.icon,
                                        size: 18,
                                        color: isSelected ? Colors.white : AppTheme.primaryColor,
                                      ),
                                      label: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          type.displayName,
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
                                          _selectedTravelerType = selected ? type : null;
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
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Input Fields with glassmorphism
                    AnimatedGlassCard(
                      delay: const Duration(milliseconds: 300),
                      blur: 8.0,
                      opacity: 0.15,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _destinationController,
                              decoration: const InputDecoration(
                                labelText: 'Destination *',
                                hintText: 'e.g., Paris, France',
                                prefixIcon: Icon(Icons.location_on),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_selectedSuggestionType == 'day_plan' ||
                                _selectedSuggestionType == 'budget')
                              TextFormField(
                                controller: _durationController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Number of Days *',
                                  hintText: 'e.g., 7',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            if (_selectedSuggestionType == 'day_plan' ||
                                _selectedSuggestionType == 'budget')
                              const SizedBox(height: 16),
                            TextFormField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Budget (Money in Hand) *',
                                hintText: 'e.g., 5000',
                                prefixIcon: Icon(Icons.account_balance_wallet),
                                helperText: 'Total amount available for the trip',
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Get Suggestions Button
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
                                    color: AppTheme.primaryColor.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _getSuggestions,
                                icon: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Icon(Icons.auto_awesome),
                                label: Text(
                                  _isLoading
                                      ? 'Getting Suggestions...'
                                      : 'Get AI Suggestions',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // AI Response
                    if (_aiResponseText != null) ...[
                      const SizedBox(height: 24),
                      AnimatedGlassCard(
                        delay: const Duration(milliseconds: 400),
                        blur: 10.0,
                        opacity: 0.2,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: AppTheme.primaryColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Suggestions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildAISuggestionCard(_aiResponseText!),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // Error Message
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 24),
                      AnimatedGlassCard(
                        delay: const Duration(milliseconds: 400),
                        blur: 8.0,
                        opacity: 0.15,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: AppTheme.errorColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: AppTheme.errorColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionTypeChip(String label, String value) {
    final isSelected = _selectedSuggestionType == value;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.9),
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedSuggestionType = value;
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
    );
  }

  Widget _buildAISuggestionCard(String responseText) {
    IconData icon;
    String title;
    
    switch (_selectedSuggestionType) {
      case 'best_time':
        icon = Icons.calendar_today;
        title = 'Best Time to Visit ${_destinationController.text}';
        break;
      case 'day_plan':
        icon = Icons.route;
        title = '${_durationController.text.isNotEmpty ? _durationController.text : "7"}-Day Itinerary for ${_destinationController.text}';
        break;
      case 'budget':
        icon = Icons.account_balance_wallet;
        title = 'Budget Breakdown for ${_destinationController.text}';
        break;
      default:
        icon = Icons.auto_awesome;
        title = 'AI Suggestions';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              responseText,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Save suggestion
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Suggestion saved')),
                    );
                  },
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('Save'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Apply to trip
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Applied to trip')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
