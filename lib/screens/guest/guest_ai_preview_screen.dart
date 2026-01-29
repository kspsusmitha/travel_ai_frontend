import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/user.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

/// Guest AI Trip Planner Preview Screen
class GuestAIPreviewScreen extends StatefulWidget {
  const GuestAIPreviewScreen({super.key});

  @override
  State<GuestAIPreviewScreen> createState() => _GuestAIPreviewScreenState();
}

class _GuestAIPreviewScreenState extends State<GuestAIPreviewScreen> {
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _durationController = TextEditingController();
  UserType? _selectedTravelerType;
  bool _isLoading = false;
  String? _previewSuggestion;

  @override
  void dispose() {
    _destinationController.dispose();
    _budgetController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _getPreviewSuggestion() async {
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a destination'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_selectedTravelerType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your traveler type'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _previewSuggestion = null;
    });

    // Simulate AI preview generation
    await Future.delayed(const Duration(seconds: 2));

    // Generate sample preview based on inputs
    final days = _durationController.text.isNotEmpty ? _durationController.text : '7';
    final budget = _budgetController.text.isNotEmpty ? _budgetController.text : '5000';
    final destination = _destinationController.text;
    final travelerType = _selectedTravelerType!.displayName;

    setState(() {
      _previewSuggestion = '''
🎯 **Preview Trip Suggestion for $destination**

**Traveler Type:** $travelerType
**Duration:** $days days
**Budget:** \$$budget

**Sample Itinerary Preview:**
Day 1: Arrival and city exploration
Day 2: Main attractions and landmarks
Day 3: Cultural experiences and local cuisine
Day 4: Adventure activities or relaxation
Day 5: Shopping and local markets
Day 6: Day trip to nearby attractions
Day 7: Departure

**Estimated Budget Breakdown:**
• Accommodation: \$${(double.parse(budget) * 0.3).toStringAsFixed(0)} (30%)
• Food & Dining: \$${(double.parse(budget) * 0.25).toStringAsFixed(0)} (25%)
• Activities & Tours: \$${(double.parse(budget) * 0.25).toStringAsFixed(0)} (25%)
• Transportation: \$${(double.parse(budget) * 0.15).toStringAsFixed(0)} (15%)
• Miscellaneous: \$${(double.parse(budget) * 0.05).toStringAsFixed(0)} (5%)

⚠️ **This is a preview only. Register to get:**
• Complete day-by-day itinerary
• Hotel booking recommendations
• Real-time AI suggestions
• Save and modify trip plans
• Booking history
      ''';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Trip Planner - Preview Mode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Mode Banner
            Card(
              color: AppTheme.accentColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.accentColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview Mode',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get a sample trip suggestion. Register to unlock full AI planning and booking features.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
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
            // Input Fields
            Text(
              'Trip Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination *',
                hintText: 'e.g., Paris, France',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Days *',
                hintText: 'e.g., 7',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget (Optional)',
                hintText: 'e.g., 5000',
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
            ),
            const SizedBox(height: 24),
            // Traveler Type Selection
            Text(
              'Traveler Type *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: UserType.values.map((type) {
                final isSelected = _selectedTravelerType == type;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type.icon,
                        size: 18,
                        color: isSelected ? Colors.white : AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(type.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTravelerType = selected ? type : null;
                    });
                  },
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            // Get Preview Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _getPreviewSuggestion,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isLoading ? 'Generating Preview...' : 'Get Preview Suggestion',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            // Preview Result
            if (_previewSuggestion != null) ...[
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Preview Suggestion',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _previewSuggestion!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Register CTA
              Card(
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unlock Full Features',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register now to access complete AI trip planning, hotel bookings, and itinerary management.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
