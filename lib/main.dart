import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/user_selection_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
// Guest screens
import 'screens/guest/guest_landing_screen.dart';
// Admin screens
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
// Super Admin screens
import 'screens/super_admin/super_admin_login_screen.dart';
import 'screens/super_admin/super_admin_dashboard_screen.dart';

void main() {
  runApp(const TripMateApp());
}

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        // Splash and User Selection
        '/': (context) => const SplashScreen(),
        '/user-selection': (context) => const UserSelectionScreen(),
        
        // Regular User routes
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        
        // Guest routes
        '/guest': (context) => const GuestLandingScreen(),
        
        // Admin routes
        '/admin/login': (context) => const AdminLoginScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        
        // Super Admin routes
        '/super-admin/login': (context) => const SuperAdminLoginScreen(),
        '/super-admin/dashboard': (context) => const SuperAdminDashboardScreen(),
      },
    );
  }
}
