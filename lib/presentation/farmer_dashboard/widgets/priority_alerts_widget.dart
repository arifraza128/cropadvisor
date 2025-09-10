import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PriorityAlertsWidget extends StatefulWidget {
  const PriorityAlertsWidget({super.key});

  @override
  State<PriorityAlertsWidget> createState() => _PriorityAlertsWidgetState();
}

class _PriorityAlertsWidgetState extends State<PriorityAlertsWidget> {
  List<Map<String, dynamic>> alerts = [
    {
      "id": 1,
      "type": "pest_warning",
      "title": "Pest Alert: Aphids Detected",
      "description":
          "High aphid activity reported in nearby fields. Check your crops immediately.",
      "priority": "high",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "icon": "bug_report",
      "color": Colors.red,
    },
    {
      "id": 2,
      "type": "irrigation",
      "title": "Irrigation Reminder",
      "description":
          "Tomato field requires watering. Soil moisture is below optimal level.",
      "priority": "medium",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "icon": "water_drop",
      "color": Colors.blue,
    },
    {
      "id": 3,
      "type": "market_price",
      "title": "Price Alert: Wheat",
      "description":
          "Wheat prices increased by 8% in local market. Good time to sell.",
      "priority": "medium",
      "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
      "icon": "trending_up",
      "color": Colors.green,
    },
    {
      "id": 4,
      "type": "weather",
      "title": "Weather Warning",
      "description":
          "Heavy rainfall expected in next 48 hours. Secure your crops.",
      "priority": "high",
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      "icon": "thunderstorm",
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (alerts.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.green,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'All Clear!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'No urgent alerts at the moment. Your farm is doing well.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'priority_high',
                  color: colorScheme.error,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Priority Alerts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${alerts.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: alerts.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertCard(context, alert, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(
      BuildContext context, Map<String, dynamic> alert, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final alertColor = alert["color"] as Color;
    final isHighPriority = alert["priority"] == "high";

    return Dismissible(
      key: Key('alert_${alert["id"]}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          alerts.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alert dismissed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  alerts.insert(index, alert);
                });
              },
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: colorScheme.onError,
          size: 24,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighPriority
                ? colorScheme.error.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isHighPriority ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: alertColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: alert["icon"] as String,
                color: alertColor,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert["title"] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isHighPriority)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5.w, vertical: 0.3.h),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'URGENT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.w700,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    alert["description"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _formatTimestamp(alert["timestamp"] as DateTime),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
