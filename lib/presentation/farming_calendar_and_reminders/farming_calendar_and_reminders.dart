import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/activity_card_widget.dart';
import './widgets/add_activity_form_widget.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/crop_tab_widget.dart';
import './widgets/smart_suggestions_widget.dart';

class FarmingCalendarAndReminders extends StatefulWidget {
  const FarmingCalendarAndReminders({super.key});

  @override
  State<FarmingCalendarAndReminders> createState() =>
      _FarmingCalendarAndRemindersState();
}

class _FarmingCalendarAndRemindersState
    extends State<FarmingCalendarAndReminders> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _selectedCropIndex = 0;
  int _currentBottomNavIndex = 4;
  bool _showAddActivityForm = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Mock data for farming activities
  final List<Map<String, dynamic>> _activities = [
    {
      'id': 1,
      'name': 'Rice Transplanting',
      'type': 'planting',
      'crop': 'rice',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '6:00 AM',
      'description':
          'Transplant rice seedlings to main field with proper spacing',
      'isCompleted': false,
      'weatherSuitable': true,
      'resources': ['Seedlings', 'Tools', 'Water'],
      'reminderTiming': 'day_before',
    },
    {
      'id': 2,
      'name': 'Wheat Irrigation',
      'type': 'irrigation',
      'crop': 'wheat',
      'date': DateTime.now(),
      'time': '7:00 AM',
      'description': 'Apply irrigation to wheat crop - second watering cycle',
      'isCompleted': false,
      'weatherSuitable': false,
      'resources': ['Water', 'Irrigation equipment'],
      'reminderTiming': 'morning_of',
    },
    {
      'id': 3,
      'name': 'Tomato Fertilization',
      'type': 'fertilization',
      'crop': 'tomato',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '8:00 AM',
      'description': 'Apply NPK fertilizer to tomato plants for better growth',
      'isCompleted': true,
      'weatherSuitable': true,
      'resources': ['NPK Fertilizer', 'Sprayer'],
      'reminderTiming': '2_hours_before',
    },
    {
      'id': 4,
      'name': 'Pest Control - Cotton',
      'type': 'pest_control',
      'crop': 'cotton',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '5:30 AM',
      'description': 'Apply pesticide spray to control bollworm infestation',
      'isCompleted': false,
      'weatherSuitable': true,
      'resources': ['Pesticide', 'Protective gear', 'Sprayer'],
      'reminderTiming': 'day_before',
    },
    {
      'id': 5,
      'name': 'Corn Harvesting',
      'type': 'harvesting',
      'crop': 'corn',
      'date': DateTime.now().add(const Duration(days: 7)),
      'time': '6:30 AM',
      'description':
          'Harvest mature corn cobs when moisture content is optimal',
      'isCompleted': false,
      'weatherSuitable': true,
      'resources': ['Harvesting tools', 'Storage bags'],
      'reminderTiming': 'day_before',
    },
  ];

  final List<Map<String, dynamic>> _crops = [
    {
      'name': 'All Crops',
      'type': 'all',
      'growthStage': null,
    },
    {
      'name': 'Rice',
      'type': 'rice',
      'growthStage': 'Vegetative',
    },
    {
      'name': 'Wheat',
      'type': 'wheat',
      'growthStage': 'Flowering',
    },
    {
      'name': 'Tomato',
      'type': 'tomato',
      'growthStage': 'Fruiting',
    },
    {
      'name': 'Cotton',
      'type': 'cotton',
      'growthStage': 'Boll Formation',
    },
    {
      'name': 'Corn',
      'type': 'corn',
      'growthStage': 'Maturity',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CalendarHeaderWidget(
                  currentDate: _focusedDay,
                  seasonIndicator: _getCurrentSeason(),
                  onPreviousMonth: () => _changeMonth(-1),
                  onNextMonth: () => _changeMonth(1),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCalendarView(),
                      _buildCropSpecificView(),
                    ],
                  ),
                ),
              ],
            ),

            // Tab Bar
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Calendar View'),
                    Tab(text: 'Crop Timeline'),
                  ],
                  labelColor: AppTheme.lightTheme.colorScheme.primary,
                  unselectedLabelColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  indicator: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                ),
              ),
            ),

            // Add Activity Form
            if (_showAddActivityForm)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AddActivityFormWidget(
                      onActivityAdded: _addActivity,
                      onCancel: () =>
                          setState(() => _showAddActivityForm = false),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _showAddActivityForm = true),
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 6.w,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) => setState(() => _currentBottomNavIndex = index),
      ),
    );
  }

  Widget _buildCalendarView() {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: 8.h), // Space for tab bar

        // Smart Suggestions
        SmartSuggestionsWidget(
          onSuggestionTap: _addSuggestedActivity,
        ),

        // Calendar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TableCalendar<Map<String, dynamic>>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorLight,
              ) ?? const TextStyle(color: AppTheme.errorLight),
              holidayTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorLight,
              ) ?? const TextStyle(color: AppTheme.errorLight),
              selectedDecoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppTheme.warningLight,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
          ),
        ),

        SizedBox(height: 2.h),

        // Activities for selected day
        Expanded(
          child: _buildActivitiesList(_getEventsForDay(_selectedDay)),
        ),
      ],
    );
  }

  Widget _buildCropSpecificView() {
    return Column(
      children: [
        SizedBox(height: 8.h), // Space for tab bar

        // Crop Tabs
        CropTabWidget(
          crops: _crops,
          selectedCropIndex: _selectedCropIndex,
          onCropSelected: (index) => setState(() => _selectedCropIndex = index),
        ),

        // Crop-specific activities
        Expanded(
          child: _buildActivitiesList(_getCropSpecificActivities()),
        ),
      ],
    );
  }

  Widget _buildActivitiesList(List<Map<String, dynamic>> activities) {
    final theme = Theme.of(context);

    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'event_available',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No activities scheduled',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap + to add new farming activities',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];

        return Slidable(
          key: ValueKey(activity['id']),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) =>
                    _markActivityComplete(activity['id'] as int),
                backgroundColor: AppTheme.successLight,
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Complete',
              ),
              SlidableAction(
                onPressed: (context) =>
                    _rescheduleActivity(activity['id'] as int),
                backgroundColor: AppTheme.warningLight,
                foregroundColor: Colors.white,
                icon: Icons.schedule,
                label: 'Reschedule',
              ),
              SlidableAction(
                onPressed: (context) => _deleteActivity(activity['id'] as int),
                backgroundColor: AppTheme.errorLight,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ActivityCardWidget(
            activity: activity,
            onTap: () => _showActivityDetails(activity),
            onComplete: () => _markActivityComplete(activity['id'] as int),
            onReschedule: () => _rescheduleActivity(activity['id'] as int),
            onAddNotes: () => _addNotesToActivity(activity['id'] as int),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _activities.where((activity) {
      final activityDate = activity['date'] as DateTime;
      return isSameDay(activityDate, day);
    }).toList();
  }

  List<Map<String, dynamic>> _getCropSpecificActivities() {
    if (_selectedCropIndex == 0) {
      // All crops
      return _activities;
    }

    final selectedCrop = _crops[_selectedCropIndex];
    return _activities.where((activity) {
      return activity['crop'] == selectedCrop['type'];
    }).toList();
  }

  String _getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) {
      return 'Summer Season';
    } else if (month >= 6 && month <= 9) {
      return 'Monsoon Season';
    } else {
      return 'Winter Season';
    }
  }

  void _changeMonth(int direction) {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + direction,
        _focusedDay.day,
      );
    });
  }

  void _addActivity(Map<String, dynamic> activity) {
    setState(() {
      _activities.add(activity);
      _showAddActivityForm = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Activity "${activity['name']}" added successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _addSuggestedActivity(Map<String, dynamic> suggestion) {
    final activity = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': suggestion['title'],
      'type': suggestion['type'],
      'crop': suggestion['crop'].toString().toLowerCase(),
      'date': suggestion['date'],
      'time': '6:00 AM',
      'description': suggestion['description'],
      'isCompleted': false,
      'weatherSuitable': true,
      'resources': _getRequiredResources(suggestion['type'] as String),
      'reminderTiming': 'day_before',
    };

    setState(() => _activities.add(activity));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Suggested activity "${activity['name']}" added'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  List<String> _getRequiredResources(String activityType) {
    switch (activityType) {
      case 'planting':
        return ['Seeds', 'Tools', 'Water'];
      case 'irrigation':
        return ['Water', 'Irrigation equipment'];
      case 'fertilization':
        return ['Fertilizer', 'Sprayer'];
      case 'pest_control':
        return ['Pesticide', 'Protective gear'];
      case 'harvesting':
        return ['Harvesting tools', 'Storage containers'];
      default:
        return ['Basic tools'];
    }
  }

  void _markActivityComplete(int activityId) {
    setState(() {
      final activityIndex =
          _activities.indexWhere((a) => a['id'] == activityId);
      if (activityIndex != -1) {
        _activities[activityIndex]['isCompleted'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity marked as completed'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _rescheduleActivity(int activityId) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          final activityIndex =
              _activities.indexWhere((a) => a['id'] == activityId);
          if (activityIndex != -1) {
            _activities[activityIndex]['date'] = newDate;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity rescheduled successfully'),
            backgroundColor: AppTheme.warningLight,
          ),
        );
      }
    });
  }

  void _deleteActivity(int activityId) {
    setState(() {
      _activities.removeWhere((a) => a['id'] == activityId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity deleted'),
        backgroundColor: AppTheme.errorLight,
      ),
    );
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildActivityDetailsSheet(activity),
    );
  }

  Widget _buildActivityDetailsSheet(Map<String, dynamic> activity) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: _getActivityColor(activity['type'] as String)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: CustomIconWidget(
                  iconName: _getActivityIcon(activity['type'] as String),
                  color: _getActivityColor(activity['type'] as String),
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['name'] as String,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Crop: ${activity['crop']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (activity['description'] != null) ...[
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              activity['description'] as String,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${(activity['date'] as DateTime).day}/${(activity['date'] as DateTime).month}/${(activity['date'] as DateTime).year}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      activity['time'] as String,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: (activity['isCompleted'] as bool)
                            ? AppTheme.successLight.withValues(alpha: 0.1)
                            : AppTheme.warningLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        (activity['isCompleted'] as bool)
                            ? 'Completed'
                            : 'Pending',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: (activity['isCompleted'] as bool)
                              ? AppTheme.successLight
                              : AppTheme.warningLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (activity['resources'] != null) ...[
            SizedBox(height: 2.h),
            Text(
              'Required Resources',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: (activity['resources'] as List<String>).map((resource) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    resource,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _markActivityComplete(activity['id'] as int);
                  },
                  child: const Text('Mark Complete'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _addNotesToActivity(int activityId) {
    showDialog(
      context: context,
      builder: (context) {
        final noteController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Notes'),
          content: TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter your notes here...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final activityIndex =
                      _activities.indexWhere((a) => a['id'] == activityId);
                  if (activityIndex != -1) {
                    _activities[activityIndex]['notes'] = noteController.text;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notes added successfully'),
                    backgroundColor: AppTheme.successLight,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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