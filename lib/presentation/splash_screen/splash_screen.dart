import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Mock authentication status
  bool _isAuthenticated = false;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _initializeAnimations();
    _startInitialization();
  }

  void _setupSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.lightTheme.colorScheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startInitialization() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadFarmerProfile(),
        _fetchWeatherData(),
        _prepareCropDatabase(),
        _syncAgriculturalAdvisories(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage =
            'Failed to initialize app. Please check your connection.';
      });

      // Show error for 2 seconds then retry or navigate
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock authentication check
    _isAuthenticated = DateTime.now().millisecondsSinceEpoch % 2 == 0;
  }

  Future<void> _loadFarmerProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock profile loading
  }

  Future<void> _fetchWeatherData() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Mock weather data fetching
  }

  Future<void> _prepareCropDatabase() async {
    await Future.delayed(const Duration(milliseconds: 900));
    // Mock crop database preparation
  }

  Future<void> _syncAgriculturalAdvisories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock advisory syncing
  }

  void _navigateToNextScreen() {
    _fadeController.forward().then((_) {
      if (mounted) {
        if (_isAuthenticated) {
          // Navigate to dashboard for authenticated users
          Navigator.pushReplacementNamed(context, '/farmer-dashboard');
        } else if (_isFirstTime) {
          // Navigate to onboarding for first-time users
          Navigator.pushReplacementNamed(context, '/farmer-dashboard');
        } else {
          // Navigate to registration for returning non-authenticated users
          Navigator.pushReplacementNamed(context, '/farmer-dashboard');
        }
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isInitialized = false;
      _errorMessage = '';
    });
    _startInitialization();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - _fadeAnimation.value,
            child: _buildSplashContent(),
          );
        },
      ),
    );
  }

  Widget _buildSplashContent() {
    return SafeArea(
      child: Stack(
        children: [
          // Background gradient
          const BackgroundGradientWidget(),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                const AnimatedLogoWidget(),

                SizedBox(height: 8.h),

                // Loading indicator or error message
                _hasError ? _buildErrorWidget() : _buildLoadingWidget(),
              ],
            ),
          ),

          // Version info at bottom
          _buildVersionInfo(),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const LoadingIndicatorWidget();
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.lightTheme.colorScheme.surface,
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.surface,
              fontSize: 12.sp,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Positioned(
      bottom: 4.h,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Version 1.0.0',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            '© 2025 CropAdvisor. All rights reserved.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.6),
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }
}
