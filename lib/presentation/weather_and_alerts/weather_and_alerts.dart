import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/agricultural_alerts_widget.dart';
import './widgets/current_weather_card.dart';
import './widgets/detailed_hourly_modal.dart';
import './widgets/hourly_forecast_widget.dart';
import './widgets/weekly_forecast_widget.dart';

class WeatherAndAlerts extends StatefulWidget {
  const WeatherAndAlerts({super.key});

  @override
  State<WeatherAndAlerts> createState() => _WeatherAndAlertsState();
}

class _WeatherAndAlertsState extends State<WeatherAndAlerts> {
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _alerts = [];

  // Mock data for current weather
  final Map<String, dynamic> _currentWeather = {
    "location": "Pune, Maharashtra",
    "gpsAccuracy": 15,
    "temperature": 28,
    "condition": "Partly Cloudy",
    "feelsLike": 31,
    "humidity": 65,
    "windSpeed": 12,
    "farmingSuitability": "Ideal",
  };

  // Mock data for hourly forecast
  final List<Map<String, dynamic>> _hourlyForecast = [
    {
      "time": "12 PM",
      "temperature": 28,
      "condition": "Partly Cloudy",
      "precipitation": 10,
      "windSpeed": "12 km/h",
      "sprayingSuitable": true,
    },
    {
      "time": "1 PM",
      "temperature": 30,
      "condition": "Sunny",
      "precipitation": 5,
      "windSpeed": "8 km/h",
      "sprayingSuitable": true,
    },
    {
      "time": "2 PM",
      "temperature": 32,
      "condition": "Sunny",
      "precipitation": 0,
      "windSpeed": "6 km/h",
      "sprayingSuitable": true,
    },
    {
      "time": "3 PM",
      "temperature": 33,
      "condition": "Sunny",
      "precipitation": 0,
      "windSpeed": "10 km/h",
      "sprayingSuitable": true,
    },
    {
      "time": "4 PM",
      "temperature": 31,
      "condition": "Partly Cloudy",
      "precipitation": 15,
      "windSpeed": "14 km/h",
      "sprayingSuitable": false,
    },
    {
      "time": "5 PM",
      "temperature": 29,
      "condition": "Cloudy",
      "precipitation": 25,
      "windSpeed": "18 km/h",
      "sprayingSuitable": false,
    },
  ];

  // Mock data for weekly forecast
  final List<Map<String, dynamic>> _weeklyForecast = [
    {
      "day": "Today",
      "date": "09 Sep",
      "condition": "Partly Cloudy",
      "highTemp": 33,
      "lowTemp": 22,
      "rainfall": 2,
      "farmingRecommendation":
          "Good day for irrigation and light field work. Avoid heavy machinery due to soil moisture.",
      "hourlyDetails": [
        {
          "time": "6:00 AM",
          "temperature": 22,
          "condition": "Clear",
          "feelsLike": 24,
          "humidity": 78,
          "windSpeed": 8,
          "windDirection": "NE",
          "precipitation": 0,
          "uvIndex": 2,
          "sprayingSuitable": true,
          "sprayingReason": "",
        },
        {
          "time": "9:00 AM",
          "temperature": 26,
          "condition": "Partly Cloudy",
          "feelsLike": 28,
          "humidity": 65,
          "windSpeed": 10,
          "windDirection": "E",
          "precipitation": 5,
          "uvIndex": 5,
          "sprayingSuitable": true,
          "sprayingReason": "",
        },
        {
          "time": "12:00 PM",
          "temperature": 30,
          "condition": "Partly Cloudy",
          "feelsLike": 33,
          "humidity": 55,
          "windSpeed": 12,
          "windDirection": "SE",
          "precipitation": 10,
          "uvIndex": 8,
          "sprayingSuitable": true,
          "sprayingReason": "",
        },
        {
          "time": "3:00 PM",
          "temperature": 33,
          "condition": "Sunny",
          "feelsLike": 36,
          "humidity": 45,
          "windSpeed": 15,
          "windDirection": "S",
          "precipitation": 0,
          "uvIndex": 9,
          "sprayingSuitable": false,
          "sprayingReason": "High wind speed and UV index",
        },
        {
          "time": "6:00 PM",
          "temperature": 28,
          "condition": "Partly Cloudy",
          "feelsLike": 30,
          "humidity": 60,
          "windSpeed": 8,
          "windDirection": "SW",
          "precipitation": 15,
          "uvIndex": 3,
          "sprayingSuitable": true,
          "sprayingReason": "",
        },
      ],
    },
    {
      "day": "Tomorrow",
      "date": "10 Sep",
      "condition": "Rainy",
      "highTemp": 27,
      "lowTemp": 20,
      "rainfall": 15,
      "farmingRecommendation":
          "Avoid field activities. Good time for indoor farm planning and equipment maintenance.",
      "hourlyDetails": [
        {
          "time": "6:00 AM",
          "temperature": 20,
          "condition": "Rainy",
          "feelsLike": 22,
          "humidity": 85,
          "windSpeed": 15,
          "windDirection": "W",
          "precipitation": 80,
          "uvIndex": 1,
          "sprayingSuitable": false,
          "sprayingReason": "Rain and high humidity",
        },
      ],
    },
    {
      "day": "Wednesday",
      "date": "11 Sep",
      "condition": "Sunny",
      "highTemp": 31,
      "lowTemp": 19,
      "rainfall": 0,
      "farmingRecommendation":
          "Excellent day for harvesting, planting, and spraying activities. Optimal soil conditions.",
      "hourlyDetails": [],
    },
    {
      "day": "Thursday",
      "date": "12 Sep",
      "condition": "Partly Cloudy",
      "highTemp": 29,
      "lowTemp": 21,
      "rainfall": 3,
      "farmingRecommendation":
          "Good for most farming activities. Monitor afternoon weather for potential light showers.",
      "hourlyDetails": [],
    },
    {
      "day": "Friday",
      "date": "13 Sep",
      "condition": "Cloudy",
      "highTemp": 26,
      "lowTemp": 18,
      "rainfall": 8,
      "farmingRecommendation":
          "Suitable for greenhouse work and covered farming activities. Prepare for weekend rain.",
      "hourlyDetails": [],
    },
    {
      "day": "Saturday",
      "date": "14 Sep",
      "condition": "Thunderstorm",
      "highTemp": 24,
      "lowTemp": 17,
      "rainfall": 25,
      "farmingRecommendation":
          "Stay indoors. Secure loose equipment and protect sensitive crops from strong winds.",
      "hourlyDetails": [],
    },
    {
      "day": "Sunday",
      "date": "15 Sep",
      "condition": "Partly Cloudy",
      "highTemp": 28,
      "lowTemp": 19,
      "rainfall": 5,
      "farmingRecommendation":
          "Post-storm assessment day. Check for crop damage and plan recovery activities.",
      "hourlyDetails": [],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  void _loadAlerts() {
    _alerts = [
      {
        "id": 1,
        "type": "Heavy Rain",
        "severity": "High",
        "title": "Heavy Rainfall Alert",
        "description":
            "Heavy rainfall expected in the next 24 hours. Rainfall amount: 50-75mm",
        "time": "2 hours ago",
        "affectedCrops": ["Rice", "Cotton", "Sugarcane"],
        "recommendedActions":
            "Ensure proper drainage in fields. Harvest mature crops if possible. Protect seedlings with covers.",
      },
      {
        "id": 2,
        "type": "Spraying",
        "severity": "Medium",
        "title": "Optimal Spraying Window",
        "description":
            "Perfect conditions for pesticide and fertilizer spraying activities",
        "time": "30 minutes ago",
        "affectedCrops": ["Wheat", "Maize", "Vegetables"],
        "recommendedActions":
            "Wind speed is ideal (8-12 km/h). Temperature and humidity are optimal. Plan spraying for early morning or evening.",
      },
      {
        "id": 3,
        "type": "Frost",
        "severity": "Low",
        "title": "Frost Warning",
        "description":
            "Possible frost conditions in early morning hours (4-6 AM)",
        "time": "1 day ago",
        "affectedCrops": ["Tomatoes", "Peppers", "Leafy Greens"],
        "recommendedActions":
            "Cover sensitive plants. Use frost protection methods like sprinklers or row covers. Harvest mature vegetables.",
      },
    ];
  }

  Future<void> _refreshWeatherData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you would fetch fresh data from weather API
    // For now, we'll just reload the alerts
    _loadAlerts();

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Weather data updated successfully"),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onAlertDismiss(int index) {
    setState(() {
      _alerts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Alert dismissed"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDetailedHourlyModal(Map<String, dynamic> dayData) {
    if ((dayData["hourlyDetails"] as List).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Detailed hourly data not available for this day"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailedHourlyModal(dayData: dayData),
    );
  }

  void _openWeatherSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsModal(),
    );
  }

  Widget _buildSettingsModal() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Weather Settings",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            thickness: 1,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              children: [
                _buildSettingsTile(
                  "Temperature Unit",
                  "Celsius (°C)",
                  'thermostat',
                  () {},
                ),
                _buildSettingsTile(
                  "Alert Notifications",
                  "All alerts enabled",
                  'notifications',
                  () {},
                ),
                _buildSettingsTile(
                  "Location Services",
                  "GPS enabled",
                  'location_on',
                  () {},
                ),
                _buildSettingsTile(
                  "Forecast Language",
                  "English",
                  'language',
                  () {},
                ),
                _buildSettingsTile(
                  "Data Refresh",
                  "Every 30 minutes",
                  'refresh',
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
      String title, String subtitle, String iconName, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: colorScheme.onSurface.withValues(alpha: 0.5),
        size: 20,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'cloud',
              color: colorScheme.onPrimary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              "Weather & Alerts",
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _openWeatherSettings,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeatherData,
        color: colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Weather Card
              CurrentWeatherCard(currentWeather: _currentWeather),

              // Hourly Forecast
              HourlyForecastWidget(hourlyData: _hourlyForecast),

              SizedBox(height: 2.h),

              // Agricultural Alerts
              AgriculturalAlertsWidget(
                alerts: _alerts,
                onAlertDismiss: _onAlertDismiss,
              ),

              SizedBox(height: 2.h),

              // Weekly Forecast
              WeeklyForecastWidget(
                weeklyData: _weeklyForecast,
                onDayLongPress: _showDetailedHourlyModal,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Share weather data functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Weather data shared successfully"),
              duration: Duration(seconds: 2),
            ),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'share',
          color: colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          "Share",
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
