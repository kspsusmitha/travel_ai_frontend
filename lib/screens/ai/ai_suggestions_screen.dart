import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AISuggestionsScreen extends StatefulWidget {
  const AISuggestionsScreen({super.key});

  @override
  State<AISuggestionsScreen> createState() => _AISuggestionsScreenState();
}

class _AISuggestionsScreenState extends State<AISuggestionsScreen> {
  final _destinationController = TextEditingController();
  final _durationController = TextEditingController();
  final _budgetController = TextEditingController();
  String _selectedSuggestionType = 'best_time';

  @override
  void dispose() {
    _destinationController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _getSuggestions() {
    // TODO: Implement API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI suggestions will be available after API integration')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Card(
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppTheme.primaryColor, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI-Powered Suggestions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get personalized recommendations for your trip',
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
            // Suggestion Type Selection
            Text(
              'What would you like suggestions for?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionTypeChip('Best Time to Visit', 'best_time'),
                _buildSuggestionTypeChip('Day-wise Plan', 'day_plan'),
                _buildSuggestionTypeChip('Budget Breakdown', 'budget'),
              ],
            ),
            const SizedBox(height: 24),
            // Input Fields
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination *',
                hintText: 'e.g., Paris, France',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedSuggestionType == 'day_plan' || _selectedSuggestionType == 'budget')
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (days) *',
                  hintText: 'e.g., 7',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
            if (_selectedSuggestionType == 'day_plan' || _selectedSuggestionType == 'budget')
              const SizedBox(height: 16),
            if (_selectedSuggestionType == 'budget')
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Budget (Optional)',
                  hintText: 'e.g., 5000',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
              ),
            const SizedBox(height: 32),
            // Get Suggestions Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _getSuggestions,
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'Get AI Suggestions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Example Suggestions (Mock Data)
            Text(
              'Example Suggestions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSuggestionCard(
              title: 'Best Time to Visit Paris',
              content: 'The best time to visit Paris is during spring (April to June) or fall (September to October) when the weather is mild and tourist crowds are smaller.',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            _buildSuggestionCard(
              title: '7-Day Paris Itinerary',
              content: 'Day 1: Eiffel Tower, Seine Cruise\nDay 2: Louvre Museum, Tuileries Garden\nDay 3: Montmartre, Sacré-Cœur\nDay 4: Versailles Day Trip\nDay 5: Notre-Dame, Latin Quarter\nDay 6: Shopping, Champs-Élysées\nDay 7: Local Markets, Departure',
              icon: Icons.route,
            ),
            const SizedBox(height: 12),
            _buildSuggestionCard(
              title: 'Budget Breakdown for Paris',
              content: 'Accommodation: \$1,500 (30%)\nFood: \$700 (14%)\nTransport: \$400 (8%)\nActivities: \$1,200 (24%)\nShopping: \$800 (16%)\nEmergency: \$400 (8%)',
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionTypeChip(String label, String value) {
    final isSelected = _selectedSuggestionType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSuggestionType = value;
        });
      },
    );
  }

  Widget _buildSuggestionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
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
              content,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Save suggestion
                  },
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('Save'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Apply to trip
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
