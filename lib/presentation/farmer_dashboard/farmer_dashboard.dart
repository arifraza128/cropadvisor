import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/crop_status_widget.dart';
import './widgets/priority_alerts_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/weather_card_widget.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isLoading = false;
  int _currentBottomNavIndex = 0;

  // Mock farmer data
  final Map<String, dynamic> farmerData = {
    "name": "राज पटेल", // Raj Patel in Hindi
    "location": "Pune, Maharashtra",
    "totalArea": "12.5 acres",
    "activeCrops": 4,
    "lastSync": DateTime.now().subtract(const Duration(minutes: 5)),
  };

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFarmerGreeting(context),
                  const WeatherCardWidget(),
                  const PriorityAlertsWidget(),
                  const CropStatusWidget(),
                  const QuickActionsWidget(),
                  SizedBox(height: 10.h), // Space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'agriculture',
            color: colorScheme.onPrimary,
            size: 28,
          ),
          SizedBox(width: 2.w),
          Text(
            'CropAdvisor',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: CustomIconWidget(
                iconName: 'notifications_outlined',
                color: colorScheme.onPrimary,
                size: 24,
              ),
              onPressed: () {
                // Handle notification tap
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '3',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: _isOnline() ? 'wifi' : 'wifi_off',
            color: _isOnline() ? colorScheme.onPrimary : colorScheme.error,
            size: 24,
          ),
          onPressed: () {
            _showConnectivityStatus(context);
          },
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildFarmerGreeting(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'नमस्ते, ${farmerData["name"]}', // Hello in Hindi
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          farmerData["location"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildFarmStat(
                  context,
                  'Total Area',
                  farmerData["totalArea"] as String,
                  'landscape',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildFarmStat(
                  context,
                  'Active Crops',
                  '${farmerData["activeCrops"]}',
                  'agriculture',
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'sync',
                color: colorScheme.onPrimary.withValues(alpha: 0.7),
                size: 14,
              ),
              SizedBox(width: 1.w),
              Text(
                'Last synced: ${_formatLastSync(farmerData["lastSync"] as DateTime)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFarmStat(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: colorScheme.onPrimary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: _handleBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: 8.0,
      selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w400,
      ),
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard_outlined',
            color: _currentBottomNavIndex == 0
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'dashboard',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'agriculture_outlined',
            color: _currentBottomNavIndex == 1
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'agriculture',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Crops',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'cloud_outlined',
            color: _currentBottomNavIndex == 2
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'cloud',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Weather',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'trending_up_outlined',
            color: _currentBottomNavIndex == 3
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'trending_up',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person_outlined',
            color: _currentBottomNavIndex == 4
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'person',
            color: colorScheme.primary,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: _showQuickCaptureOptions,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 6.0,
        icon: CustomIconWidget(
          iconName: 'camera_alt',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Quick Capture',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate data refresh with haptic feedback
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      farmerData["lastSync"] = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Agricultural data synced successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    final routes = [
      '/farmer-dashboard',
      '/crop-selection-and-management',
      '/weather-and-alerts',
      '/farmer-dashboard', // Market placeholder
      '/farmer-dashboard', // Profile placeholder
    ];

    if (index != 0 && index < routes.length) {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  void _showQuickCaptureOptions() {
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
              'Quick Capture',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildQuickCaptureOption(
              context,
              'Crop Health Check',
              'Take photo for AI diagnosis',
              'camera_alt',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/crop-health-scanner');
              },
            ),
            _buildQuickCaptureOption(
              context,
              'Field Notes',
              'Add voice or text notes',
              'note_add',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/farming-calendar-and-reminders');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCaptureOption(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: colorScheme.onSurface.withValues(alpha: 0.4),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showConnectivityStatus(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOnline = _isOnline();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: isOnline ? 'wifi' : 'wifi_off',
              color: colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              isOnline
                  ? 'Connected to internet'
                  : 'Offline mode - cached data shown',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: isOnline ? colorScheme.primary : colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  bool _isOnline() {
    // Mock connectivity status - in real app, use connectivity_plus package
    return DateTime.now().millisecond % 2 == 0;
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
