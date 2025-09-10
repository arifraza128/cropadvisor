import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyData;

  const HourlyForecastWidget({
    super.key,
    required this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              "Hourly Forecast",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: hourlyData.length,
              itemBuilder: (context, index) {
                final hour = hourlyData[index];
                return Container(
                  width: 20.w,
                  margin: EdgeInsets.only(right: 3.w),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        hour["time"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: _getWeatherIcon(hour["condition"] as String),
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      Text(
                        "${hour["temperature"]}°",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'water_drop',
                            color: Colors.blue,
                            size: 12,
                          ),
                          SizedBox(width: 0.5.w),
                          Text(
                            "${hour["precipitation"]}%",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'air',
                            color: Colors.grey,
                            size: 12,
                          ),
                          SizedBox(width: 0.5.w),
                          Text(
                            "${hour["windSpeed"]}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getSprayingSuitabilityColor(
                              hour["sprayingSuitable"] as bool),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hour["sprayingSuitable"] as bool ? "Good" : "Poor",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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

  Color _getSprayingSuitabilityColor(bool suitable) {
    return suitable ? Colors.green : Colors.red;
  }
}
