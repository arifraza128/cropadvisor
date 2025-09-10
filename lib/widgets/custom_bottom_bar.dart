import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  standard,
  floating,
  notched,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final CustomBottomBarVariant variant;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = _getNavigationItems();

    switch (variant) {
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, items);
      case CustomBottomBarVariant.notched:
        return _buildNotchedBottomBar(context, items);
      default:
        return _buildStandardBottomBar(context, items);
    }
  }

  Widget _buildStandardBottomBar(
      BuildContext context, List<BottomNavigationBarItem> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: selectedItemColor ?? colorScheme.primary,
      unselectedItemColor:
          unselectedItemColor ?? colorScheme.onSurface.withAlpha(153),
      elevation: elevation ?? 4.0,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      items: items,
    );
  }

  Widget _buildFloatingBottomBar(
      BuildContext context, List<BottomNavigationBarItem> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(38),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor:
              unselectedItemColor ?? colorScheme.onSurface.withAlpha(153),
          elevation: 0,
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: items,
        ),
      ),
    );
  }

  Widget _buildNotchedBottomBar(
      BuildContext context, List<BottomNavigationBarItem> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomAppBar(
      color: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 4.0,
      notchMargin: 8.0,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            // Skip middle item for FAB space in notched variant
            if (index == items.length ~/ 2) {
              return const SizedBox(width: 40);
            }

            return GestureDetector(
              onTap: () => _handleNavigation(context, index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected
                        ? (item.activeIcon as Icon?)?.icon ??
                            (item.icon as Icon).icon
                        : (item.icon as Icon).icon,
                    color: isSelected
                        ? (selectedItemColor ?? colorScheme.primary)
                        : (unselectedItemColor ??
                            colorScheme.onSurface.withAlpha(153)),
                    size: 24,
                  ),
                  if (showLabels) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.label ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                        color: isSelected
                            ? (selectedItemColor ?? colorScheme.primary)
                            : (unselectedItemColor ??
                                colorScheme.onSurface.withAlpha(153)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.agriculture_outlined),
        activeIcon: Icon(Icons.agriculture),
        label: 'Crops',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt_outlined),
        activeIcon: Icon(Icons.camera_alt),
        label: 'Scanner',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.cloud_outlined),
        activeIcon: Icon(Icons.cloud),
        label: 'Weather',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined),
        activeIcon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
    ];
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    final routes = [
      '/farmer-dashboard',
      '/crop-selection-and-management',
      '/crop-health-scanner',
      '/weather-and-alerts',
      '/farming-calendar-and-reminders',
    ];

    if (index < routes.length) {
      Navigator.pushNamed(context, routes[index]);
    }

    onTap(index);
  }
}
