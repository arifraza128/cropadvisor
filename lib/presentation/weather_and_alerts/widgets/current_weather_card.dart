import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Map<String, dynamic> currentWeather;

  const CurrentWeatherCard({
    super.key,
    required this.currentWeather,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentWeather["location"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          "GPS Accuracy: ${currentWeather["gpsAccuracy"]}m",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getFarmingSuitabilityColor(
                      currentWeather["farmingSuitability"] as String),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentWeather["farmingSuitability"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${currentWeather["temperature"]}°C",
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w300,
                        fontSize: 48,
                      ),
                    ),
                    Text(
                      currentWeather["condition"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Feels like ${currentWeather["feelsLike"]}°C",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: _getWeatherIcon(
                          currentWeather["condition"] as String),
                      color: colorScheme.onPrimary,
                      size: 64,
                    ),
                    SizedBox(height: 2.h),
                    _buildWeatherDetail("Humidity",
                        "${currentWeather["humidity"]}%", 'water_drop'),
                    SizedBox(height: 1.h),
                    _buildWeatherDetail(
                        "Wind", "${currentWeather["windSpeed"]} km/h", 'air'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, String iconName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: Colors.white.withValues(alpha: 0.8),
          size: 16,
        ),
        SizedBox(width: 1.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10.sp,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getFarmingSuitabilityColor(String suitability) {
    switch (suitability.toLowerCase()) {
      case 'ideal':
        return Colors.green;
      case 'caution':
        return Colors.orange;
      case 'avoid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'cloudy':
      case 'overcast':
        return 'cloud';
      case 'partly cloudy':
        return 'partly_cloudy_day';
      case 'rainy':
      case 'rain':
        return 'umbrella';
      case 'thunderstorm':
        return 'thunderstorm';
      case 'foggy':
      case 'mist':
        return 'foggy';
      default:
        return 'wb_sunny';
    }
  }
}
