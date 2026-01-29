import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/glassmorphism.dart';

class SuperAdminAISupervisionScreen extends StatefulWidget {
  const SuperAdminAISupervisionScreen({super.key});

  @override
  State<SuperAdminAISupervisionScreen> createState() =>
      _SuperAdminAISupervisionScreenState();
}

class _SuperAdminAISupervisionScreenState
    extends State<SuperAdminAISupervisionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimations = List.generate(
      5,
      (index) =>
          Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index * 0.1,
                0.6 + (index * 0.1),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('AI System Supervision'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A237E), // Deep Indigo
              AppTheme.primaryColor,
              const Color(0xFF0D47A1), // Royal Blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideTransition(
                    position: _slideAnimations[0],
                    child: _buildOverviewSection(context),
                  ),
                  const SizedBox(height: 32),
                  SlideTransition(
                    position: _slideAnimations[1],
                    child: Text(
                      'Recent AI Interactions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInteractionList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          'Total Queries',
          '12,450',
          Icons.chat_bubble_outline,
          Colors.blue,
        ),
        _buildStatCard('Response Time', '1.2s', Icons.speed, Colors.green),
        _buildStatCard(
          'User Feedback',
          '98%',
          Icons.thumb_up_alt_outlined,
          Colors.orange,
        ),
        _buildStatCard('Flags', '23', Icons.flag_outlined, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Glassmorphism(
      blur: 15,
      opacity: 0.1,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionList() {
    final interactions = [
      {
        'user': 'john.doe@example.com',
        'query': 'Plan a 3-day trip to Paris',
        'status': 'Safe',
        'time': '2 mins ago',
        'isFlagged': false,
      },
      {
        'user': 'jane.smith@example.com',
        'query': 'Cheapest hotels near downtown',
        'status': 'Safe',
        'time': '15 mins ago',
        'isFlagged': false,
      },
      {
        'user': 'suspicious.user@example.com',
        'query': 'Generate fake reviews for Hotel X',
        'status': 'Flagged',
        'time': '1 hour ago',
        'isFlagged': true,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: interactions.length,
      itemBuilder: (context, index) {
        final item = interactions[index];
        final bool isFlagged = item['isFlagged'] == true;

        return SlideTransition(
          position: index < _slideAnimations.length - 2
              ? _slideAnimations[index + 2]
              : _slideAnimations.last,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Glassmorphism(
              blur: 10,
              opacity: 0.1,
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isFlagged ? AppTheme.errorColor : Colors.white)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFlagged ? Icons.warning_rounded : Icons.person_outline,
                    color: isFlagged ? AppTheme.errorColor : Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  item['query'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${item['user']} • ${item['time']}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isFlagged
                                ? AppTheme.errorColor
                                : AppTheme.successColor)
                            .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          (isFlagged
                                  ? AppTheme.errorColor
                                  : AppTheme.successColor)
                              .withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item['status'] as String,
                    style: TextStyle(
                      color: isFlagged
                          ? AppTheme.errorColor
                          : AppTheme.successColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
