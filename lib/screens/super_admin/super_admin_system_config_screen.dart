import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/action_dialog.dart';

/// Super Admin System Configuration Screen
class SuperAdminSystemConfigScreen extends StatefulWidget {
  const SuperAdminSystemConfigScreen({super.key});

  @override
  State<SuperAdminSystemConfigScreen> createState() => _SuperAdminSystemConfigScreenState();
}

class _SuperAdminSystemConfigScreenState extends State<SuperAdminSystemConfigScreen> {
  // Dummy configuration values
  bool _allowGuestBookings = true;
  bool _requireEmailVerification = true;
  bool _enableNotifications = true;
  int _maxBookingsPerUser = 10;
  int _bookingCancellationHours = 24;
  String _systemTimezone = 'UTC';
  String _defaultCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Settings
            Text(
              'Booking Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Allow Guest Bookings'),
                      subtitle: const Text('Allow users to book without account'),
                      value: _allowGuestBookings,
                      onChanged: (value) {
                        setState(() {
                          _allowGuestBookings = value;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Require Email Verification'),
                      subtitle: const Text('Users must verify email before booking'),
                      value: _requireEmailVerification,
                      onChanged: (value) {
                        setState(() {
                          _requireEmailVerification = value;
                        });
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Max Bookings Per User'),
                      subtitle: Text('Current: $_maxBookingsPerUser'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (_maxBookingsPerUser > 1) {
                                setState(() {
                                  _maxBookingsPerUser--;
                                });
                              }
                            },
                          ),
                          Text('$_maxBookingsPerUser'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _maxBookingsPerUser++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Cancellation Hours'),
                      subtitle: Text('Hours before booking: $_bookingCancellationHours'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (_bookingCancellationHours > 1) {
                                setState(() {
                                  _bookingCancellationHours--;
                                });
                              }
                            },
                          ),
                          Text('$_bookingCancellationHours'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _bookingCancellationHours++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Notification Settings
            Text(
              'Notification Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Send notifications for bookings and updates'),
                value: _enableNotifications,
                onChanged: (value) {
                  setState(() {
                    _enableNotifications = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            // System Settings
            Text(
              'System Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('System Timezone'),
                    subtitle: Text(_systemTimezone),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Show timezone picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Timezone picker coming soon'),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Default Currency'),
                    subtitle: Text(_defaultCurrency),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Show currency picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Currency picker coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ActionDialog.show(
                    context: context,
                    title: 'Save Configuration',
                    message: 'Are you sure you want to save these configuration changes?',
                    confirmText: 'Save',
                    confirmColor: AppTheme.successColor,
                    onConfirm: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuration saved successfully'),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Configuration'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
