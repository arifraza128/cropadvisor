import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/farming_calendar_and_reminders/farming_calendar_and_reminders.dart';
import '../presentation/farmer_dashboard/farmer_dashboard.dart';
import '../presentation/crop_selection_and_management/crop_selection_and_management.dart';
import '../presentation/crop_health_scanner/crop_health_scanner.dart';
import '../presentation/weather_and_alerts/weather_and_alerts.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String farmingCalendarAndReminders =
      '/farming-calendar-and-reminders';
  static const String farmerDashboard = '/farmer-dashboard';
  static const String cropSelectionAndManagement =
      '/crop-selection-and-management';
  static const String cropHealthScanner = '/crop-health-scanner';
  static const String weatherAndAlerts = '/weather-and-alerts';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    farmingCalendarAndReminders: (context) =>
        const FarmingCalendarAndReminders(),
    farmerDashboard: (context) => const FarmerDashboard(),
    cropSelectionAndManagement: (context) => const CropSelectionAndManagement(),
    cropHealthScanner: (context) => const CropHealthScanner(),
    weatherAndAlerts: (context) => const WeatherAndAlerts(),
    // TODO: Add your other routes here
  };
}
