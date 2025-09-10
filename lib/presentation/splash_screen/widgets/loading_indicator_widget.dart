import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingIndicatorWidget extends StatefulWidget {
  final String loadingText;

  const LoadingIndicatorWidget({
    super.key,
    this.loadingText = 'Initializing agricultural services...',
  });

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _textController;
  late Animation<double> _textFadeAnimation;

  final List<String> _loadingMessages = [
    'Initializing agricultural services...',
    'Loading farmer profile...',
    'Fetching weather data...',
    'Preparing crop database...',
    'Syncing agricultural advisories...',
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _startTextAnimation();
  }

  void _startTextAnimation() {
    _textController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _textController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _currentMessageIndex =
                    (_currentMessageIndex + 1) % _loadingMessages.length;
              });
              _startTextAnimation();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.surface,
                        AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.3),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.surface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 3.h),
        SizedBox(
          height: 6.h,
          child: AnimatedBuilder(
            animation: _textFadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _textFadeAnimation.value,
                child: Text(
                  _loadingMessages[_currentMessageIndex],
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                    fontSize: 12.sp,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
