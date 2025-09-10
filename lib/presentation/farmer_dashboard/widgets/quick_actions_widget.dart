import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> quickActions = [
      {
        "title": "Crop Doctor",
        "subtitle": "AI Diagnosis",
        "icon": "camera_alt",
        "color": Colors.green,
        "route": "/crop-health-scanner",
      },
      {
        "title": "Market Prices",
        "subtitle": "Live Rates",
        "icon": "trending_up",
        "color": Colors.blue,
        "route": "/farmer-dashboard",
      },
      {
        "title": "Weather Forecast",
        "subtitle": "7-Day Outlook",
        "icon": "cloud",
        "color": Colors.orange,
        "route": "/weather-and-alerts",
      },
      {
        "title": "Expert Consultation",
        "subtitle": "Get Advice",
        "icon": "support_agent",
        "color": Colors.purple,
        "route": "/farmer-dashboard",
      },
    ];

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
                  iconName: 'flash_on',
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Quick Actions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.5.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.4,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return _buildQuickActionCard(context, action);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context, Map<String, dynamic> action) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final actionColor = action["color"] as Color;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, action["route"] as String);
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: actionColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: action["icon"] as String,
                      color: actionColor,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                action["title"] as String,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                action["subtitle"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
