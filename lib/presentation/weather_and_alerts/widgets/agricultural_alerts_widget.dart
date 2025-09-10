import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AgriculturalAlertsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> alerts;
  final Function(int) onAlertDismiss;

  const AgriculturalAlertsWidget({
    super.key,
    required this.alerts,
    required this.onAlertDismiss,
  });

  @override
  State<AgriculturalAlertsWidget> createState() =>
      _AgriculturalAlertsWidgetState();
}

class _AgriculturalAlertsWidgetState extends State<AgriculturalAlertsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.alerts.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.green,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                "No active weather alerts. Perfect conditions for farming!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: Colors.orange,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Agricultural Alerts",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.alerts.length,
            itemBuilder: (context, index) {
              final alert = widget.alerts[index];
              return Dismissible(
                key: Key('alert_${alert["id"]}'),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  widget.onAlertDismiss(index);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 4.w),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'delete',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color:
                        _getAlertBackgroundColor(alert["severity"] as String),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getAlertBorderColor(alert["severity"] as String),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getAlertSeverityColor(
                                  alert["severity"] as String),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (alert["severity"] as String).toUpperCase(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            alert["time"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIconWidget(
                            iconName: _getAlertIcon(alert["type"] as String),
                            color: _getAlertSeverityColor(
                                alert["severity"] as String),
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert["title"] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  alert["description"] as String,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (alert["affectedCrops"] != null) ...[
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Affected Crops:",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                (alert["affectedCrops"] as List).join(", "),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'lightbulb',
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "Recommended Actions:",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              alert["recommendedActions"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getAlertBackgroundColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red.withValues(alpha: 0.1);
      case 'medium':
        return Colors.orange.withValues(alpha: 0.1);
      case 'low':
        return Colors.yellow.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Color _getAlertBorderColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red.withValues(alpha: 0.3);
      case 'medium':
        return Colors.orange.withValues(alpha: 0.3);
      case 'low':
        return Colors.yellow.withValues(alpha: 0.3);
      default:
        return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Color _getAlertSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getAlertIcon(String type) {
    switch (type.toLowerCase()) {
      case 'frost':
        return 'ac_unit';
      case 'rain':
      case 'heavy rain':
        return 'umbrella';
      case 'drought':
        return 'wb_sunny';
      case 'wind':
        return 'air';
      case 'spraying':
        return 'spray';
      case 'temperature':
        return 'thermostat';
      default:
        return 'warning';
    }
  }
}
