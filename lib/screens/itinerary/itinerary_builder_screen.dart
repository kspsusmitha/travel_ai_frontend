import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/trip.dart';
import '../../models/itinerary_item.dart';

class ItineraryBuilderScreen extends StatefulWidget {
  final Trip trip;

  const ItineraryBuilderScreen({super.key, required this.trip});

  @override
  State<ItineraryBuilderScreen> createState() => _ItineraryBuilderScreenState();
}

class _ItineraryBuilderScreenState extends State<ItineraryBuilderScreen> {
  // Mock itinerary items
  final Map<DateTime, List<ItineraryItem>> _itineraryItems = {};

  @override
  void initState() {
    super.initState();
    // Initialize with empty lists for each day
    for (int i = 0; i < widget.trip.duration; i++) {
      final date = widget.trip.startDate.add(Duration(days: i));
      _itineraryItems[date] = [];
    }
  }

  List<DateTime> get _tripDates {
    return List.generate(
      widget.trip.duration,
      (index) => widget.trip.startDate.add(Duration(days: index)),
    );
  }

  void _addItineraryItem(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => _AddItineraryItemDialog(
        trip: widget.trip,
        date: date,
        onAdd: (item) {
          setState(() {
            _itineraryItems[date]!.add(item);
            _itineraryItems[date]!.sort((a, b) => a.order.compareTo(b.order));
          });
        },
      ),
    );
  }

  void _exportPDF() {
    // TODO: Implement PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF export feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.trip.duration} Days Itinerary',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.map),
                    onPressed: () {
                      // TODO: Show map view
                    },
                    tooltip: 'Map View',
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf),
                    onPressed: _exportPDF,
                    tooltip: 'Export PDF',
                  ),
                ],
              ),
            ],
          ),
        ),
        // Itinerary List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _tripDates.length,
            itemBuilder: (context, index) {
              final date = _tripDates[index];
              final items = _itineraryItems[date] ?? [];
              return _buildDayCard(date, items, index + 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(DateTime date, List<ItineraryItem> items, int dayNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        initiallyExpanded: dayNumber == 1,
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            '$dayNumber',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          DateFormat('EEEE, MMM dd').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${items.length} items'),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: () => _addItineraryItem(date),
          tooltip: 'Add Item',
        ),
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_note,
                      size: 48,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No items planned for this day',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _addItineraryItem(date),
                      icon: const Icon(Icons.add),
                      label: const Text('Add First Item'),
                    ),
                  ],
                ),
              ),
            )
          else
            ...items.map((item) => _buildItineraryItem(item, date)),
        ],
      ),
    );
  }

  Widget _buildItineraryItem(ItineraryItem item, DateTime date) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _itineraryItems[date]!.remove(item);
        });
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(item.type).withOpacity(0.2),
          child: Icon(
            _getTypeIcon(item.type),
            color: _getTypeColor(item.type),
          ),
        ),
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description != null) Text(item.description!),
            if (item.location != null)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14),
                  const SizedBox(width: 4),
                  Text(item.location!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            if (item.time != null)
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14),
                  const SizedBox(width: 4),
                  Text(item.time!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            if (item.cost != null)
              Text(
                '\$${item.cost!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successColor,
                ),
              ),
          ],
        ),
        trailing: item.estimatedDuration != null
            ? Chip(
                label: Text('${item.estimatedDuration} min'),
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              )
            : null,
        onTap: () {
          // TODO: Show edit dialog
        },
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'landmark':
        return Icons.place;
      case 'food':
        return Icons.restaurant;
      case 'activity':
        return Icons.local_activity;
      case 'accommodation':
        return Icons.hotel;
      default:
        return Icons.place;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'landmark':
        return Colors.blue;
      case 'food':
        return Colors.orange;
      case 'activity':
        return Colors.purple;
      case 'accommodation':
        return Colors.green;
      default:
        return AppTheme.primaryColor;
    }
  }
}

class _AddItineraryItemDialog extends StatefulWidget {
  final Trip trip;
  final DateTime date;
  final Function(ItineraryItem) onAdd;

  const _AddItineraryItemDialog({
    required this.trip,
    required this.date,
    required this.onAdd,
  });

  @override
  State<_AddItineraryItemDialog> createState() => _AddItineraryItemDialogState();
}

class _AddItineraryItemDialogState extends State<_AddItineraryItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  final _costController = TextEditingController();
  final _durationController = TextEditingController();

  String _type = 'landmark';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _costController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final item = ItineraryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tripId: widget.trip.id,
        date: widget.date,
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        type: _type,
        location: _locationController.text.isNotEmpty
            ? _locationController.text
            : null,
        time: _timeController.text.isNotEmpty ? _timeController.text : null,
        cost: _costController.text.isNotEmpty
            ? double.tryParse(_costController.text)
            : null,
        estimatedDuration: _durationController.text.isNotEmpty
            ? int.tryParse(_durationController.text)
            : null,
        order: 0, // TODO: Calculate based on time
      );
      widget.onAdd(item);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Itinerary Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Type Selection
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'landmark', child: Text('Landmark')),
                  DropdownMenuItem(value: 'food', child: Text('Food Stop')),
                  DropdownMenuItem(value: 'activity', child: Text('Activity')),
                  DropdownMenuItem(value: 'accommodation', child: Text('Accommodation')),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'e.g., Eiffel Tower',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Time (Optional)',
                        hintText: 'e.g., 10:00 AM',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration (min)',
                        prefixIcon: Icon(Icons.timer),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cost (Optional)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addItem,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
