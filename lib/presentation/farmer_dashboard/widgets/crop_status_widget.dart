import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CropStatusWidget extends StatelessWidget {
  const CropStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock crop data
    final List<Map<String, dynamic>> crops = [
      {
        "id": 1,
        "name": "Tomatoes",
        "variety": "Roma",
        "plantedDate": DateTime.now().subtract(const Duration(days: 45)),
        "growthStage": "Flowering",
        "healthScore": 92,
        "nextAction": "Apply fertilizer",
        "daysToHarvest": 35,
        "image":
            "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=300&fit=crop",
        "area": "2.5 acres",
        "expectedYield": "8 tons",
      },
      {
        "id": 2,
        "name": "Wheat",
        "variety": "Durum",
        "plantedDate": DateTime.now().subtract(const Duration(days: 78)),
        "growthStage": "Grain Filling",
        "healthScore": 88,
        "nextAction": "Monitor for pests",
        "daysToHarvest": 22,
        "image":
            "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop",
        "area": "5.0 acres",
        "expectedYield": "15 tons",
      },
      {
        "id": 3,
        "name": "Corn",
        "variety": "Sweet Corn",
        "plantedDate": DateTime.now().subtract(const Duration(days: 32)),
        "growthStage": "Vegetative",
        "healthScore": 85,
        "nextAction": "Irrigation needed",
        "daysToHarvest": 68,
        "image":
            "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400&h=300&fit=crop",
        "area": "1.8 acres",
        "expectedYield": "6 tons",
      },
      {
        "id": 4,
        "name": "Soybeans",
        "variety": "Glycine Max",
        "plantedDate": DateTime.now().subtract(const Duration(days: 56)),
        "growthStage": "Pod Development",
        "healthScore": 90,
        "nextAction": "Weed control",
        "daysToHarvest": 44,
        "image":
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop",
        "area": "3.2 acres",
        "expectedYield": "4.5 tons",
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
                  iconName: 'agriculture',
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Active Crops',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/crop-selection-and-management');
                  },
                  child: Text(
                    'View All',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 28.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: crops.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final crop = crops[index];
                return _buildCropCard(context, crop);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropCard(BuildContext context, Map<String, dynamic> crop) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final healthScore = crop["healthScore"] as int;
    final healthColor = _getHealthColor(healthScore);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/crop-selection-and-management');
      },
      onLongPress: () {
        _showCropContextMenu(context, crop);
      },
      child: Container(
        width: 70.w,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: CustomImageWidget(
                imageUrl: crop["image"] as String,
                width: 70.w,
                height: 12.h,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Crop Name and Variety
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crop["name"] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                crop["variety"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: healthColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$healthScore%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: healthColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    // Growth Stage
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        crop["growthStage"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Area and Expected Yield
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            'Area',
                            crop["area"] as String,
                            'landscape',
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            'Expected',
                            crop["expectedYield"] as String,
                            'trending_up',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    // Days to Harvest
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${crop["daysToHarvest"]} days to harvest',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Next Action
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'task_alt',
                            color: colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            crop["nextAction"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 12,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.3.h),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getHealthColor(int healthScore) {
    if (healthScore >= 90) return Colors.green;
    if (healthScore >= 75) return Colors.orange;
    return Colors.red;
  }

  void _showCropContextMenu(BuildContext context, Map<String, dynamic> crop) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              crop["name"] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(context, 'View Details', 'visibility', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/crop-selection-and-management');
            }),
            _buildContextMenuItem(context, 'Set Reminder', 'alarm', () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/farming-calendar-and-reminders');
            }),
            _buildContextMenuItem(context, 'Share with Expert', 'share', () {
              Navigator.pop(context);
              // Handle share functionality
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
      BuildContext context, String title, String iconName, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}
