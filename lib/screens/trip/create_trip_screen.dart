import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/constants.dart';
import '../home/home_screen.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _tripType = AppConstants.tripTypeSolo;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _travelers = ['Current User'];

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addTraveler() {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Co-traveler'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email or Username',
              hintText: 'Enter email or username',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  setState(() {
                    _travelers.add(emailController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _createTrip() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates')),
        );
        return;
      }

      // TODO: Implement API call to create trip
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip created successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Trip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trip Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Trip Name *',
                  hintText: 'e.g., Summer in Paris',
                  prefixIcon: Icon(Icons.flight_takeoff),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trip name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Destination
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destination *',
                  hintText: 'e.g., Paris, France',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Trip Type
              Text(
                'Trip Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Solo'),
                      value: AppConstants.tripTypeSolo,
                      groupValue: _tripType,
                      onChanged: (value) {
                        setState(() {
                          _tripType = value!;
                          if (_tripType == AppConstants.tripTypeSolo) {
                            _travelers.clear();
                            _travelers.add('Current User');
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Group'),
                      value: AppConstants.tripTypeGroup,
                      groupValue: _tripType,
                      onChanged: (value) {
                        setState(() {
                          _tripType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Dates
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date *',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _startDate != null
                              ? DateFormat('MMM dd, yyyy').format(_startDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date *',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _endDate != null
                              ? DateFormat('MMM dd, yyyy').format(_endDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Budget
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget (Optional)',
                  hintText: 'e.g., 5000',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Tell us about your trip...',
                ),
              ),
              const SizedBox(height: 24),
              // Co-travelers (for group trips)
              if (_tripType == AppConstants.tripTypeGroup) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Co-travelers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton.icon(
                      onPressed: _addTraveler,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._travelers.map((traveler) => Chip(
                      label: Text(traveler),
                      onDeleted: traveler == 'Current User'
                          ? null
                          : () {
                              setState(() {
                                _travelers.remove(traveler);
                              });
                            },
                    )),
                const SizedBox(height: 16),
                // Share via link option
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.link),
                    title: const Text('Share via Link'),
                    subtitle: const Text('Generate invite link for co-travelers'),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // TODO: Implement link generation
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Create Button
              ElevatedButton(
                onPressed: _createTrip,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Create Trip',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
