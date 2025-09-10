import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityCardWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onReschedule;
  final VoidCallback? onAddNotes;

  const ActivityCardWidget({
    super.key,
    required this.activity,
    this.onTap,
    this.onComplete,
    this.onReschedule,
    this.onAddNotes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = activity['isCompleted'] as bool? ?? false;
    final activityType = activity['type'] as String? ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isCompleted
              ? AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: _getActivityColor(activityType).withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color:
                        _getActivityColor(activityType).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName: _getActivityIcon(activityType),
                    color: _getActivityColor(activityType),
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['name'] as String? ?? 'Unknown Activity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (activity['crop'] != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          'Crop: ${activity['crop']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isCompleted)
                  GestureDetector(
                    onTap: onComplete,
                    child: Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.5.w),
                      ),
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.successLight,
                        size: 4.w,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  activity['time'] as String? ?? 'All day',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                if (activity['resources'] != null) ...[
                  CustomIconWidget(
                    iconName: 'inventory',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Resources needed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
            if (activity['description'] != null) ...[
              SizedBox(height: 1.h),
              Text(
                activity['description'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (activity['weatherSuitable'] == false) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: AppTheme.warningLight,
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Weather not suitable',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'planting':
        return AppTheme.successLight;
      case 'irrigation':
        return Colors.blue;
      case 'fertilization':
        return AppTheme.warningLight;
      case 'pest_control':
        return AppTheme.errorLight;
      case 'harvesting':
        return Colors.orange;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'planting':
        return 'eco';
      case 'irrigation':
        return 'water_drop';
      case 'fertilization':
        return 'scatter_plot';
      case 'pest_control':
        return 'bug_report';
      case 'harvesting':
        return 'agriculture';
      default:
        return 'event';
    }
  }
}
