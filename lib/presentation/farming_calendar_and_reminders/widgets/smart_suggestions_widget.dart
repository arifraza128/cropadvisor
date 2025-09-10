import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartSuggestionsWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onSuggestionTap;

  const SmartSuggestionsWidget({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _getSmartSuggestions();

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.warningLight,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Smart Suggestions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warningLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Based on your location and current season',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 16.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return GestureDetector(
                  onTap: () => onSuggestionTap(suggestion),
                  child: Container(
                    width: 70.w,
                    margin: EdgeInsets.only(right: 3.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getSuggestionColor(suggestion['priority'] as String)
                              .withValues(alpha: 0.1),
                          _getSuggestionColor(suggestion['priority'] as String)
                              .withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: _getSuggestionColor(
                                suggestion['priority'] as String)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: _getSuggestionColor(
                                        suggestion['priority'] as String)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: CustomIconWidget(
                                iconName: suggestion['icon'] as String,
                                color: _getSuggestionColor(
                                    suggestion['priority'] as String),
                                size: 5.w,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion['title'] as String,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    suggestion['crop'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getSuggestionColor(
                                    suggestion['priority'] as String),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Text(
                                suggestion['priority'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          suggestion['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 3.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              suggestion['timing'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                'Add',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSmartSuggestions() {
    final currentMonth = DateTime.now().month;
    final suggestions = <Map<String, dynamic>>[];

    // Season-based suggestions
    if (currentMonth >= 6 && currentMonth <= 9) {
      // Monsoon season suggestions
      suggestions.addAll([
        {
          'title': 'Rice Transplanting',
          'crop': 'Rice',
          'description':
              'Optimal time for rice transplanting during monsoon season',
          'timing': 'Next 7 days',
          'priority': 'High',
          'icon': 'grass',
          'type': 'planting',
          'date': DateTime.now().add(const Duration(days: 2)),
        },
        {
          'title': 'Drainage Check',
          'crop': 'All crops',
          'description': 'Check field drainage to prevent waterlogging',
          'timing': 'This week',
          'priority': 'Medium',
          'icon': 'water_drop',
          'type': 'irrigation',
          'date': DateTime.now().add(const Duration(days: 1)),
        },
      ]);
    } else if (currentMonth >= 10 && currentMonth <= 2) {
      // Winter season suggestions
      suggestions.addAll([
        {
          'title': 'Wheat Sowing',
          'crop': 'Wheat',
          'description': 'Perfect weather conditions for wheat sowing',
          'timing': 'Next 10 days',
          'priority': 'High',
          'icon': 'agriculture',
          'type': 'planting',
          'date': DateTime.now().add(const Duration(days: 3)),
        },
        {
          'title': 'Pest Control',
          'crop': 'Vegetables',
          'description': 'Apply preventive pest control measures',
          'timing': 'This weekend',
          'priority': 'Medium',
          'icon': 'bug_report',
          'type': 'pest_control',
          'date': DateTime.now().add(const Duration(days: 5)),
        },
      ]);
    } else {
      // Summer season suggestions
      suggestions.addAll([
        {
          'title': 'Irrigation Schedule',
          'crop': 'All crops',
          'description':
              'Increase irrigation frequency due to high temperature',
          'timing': 'Daily',
          'priority': 'High',
          'icon': 'water_drop',
          'type': 'irrigation',
          'date': DateTime.now().add(const Duration(days: 1)),
        },
        {
          'title': 'Mulching',
          'crop': 'Vegetables',
          'description': 'Apply mulch to conserve soil moisture',
          'timing': 'This week',
          'priority': 'Medium',
          'icon': 'eco',
          'type': 'fertilization',
          'date': DateTime.now().add(const Duration(days: 2)),
        },
      ]);
    }

    return suggestions;
  }

  Color _getSuggestionColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
