import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddActivityFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onActivityAdded;
  final VoidCallback onCancel;

  const AddActivityFormWidget({
    super.key,
    required this.onActivityAdded,
    required this.onCancel,
  });

  @override
  State<AddActivityFormWidget> createState() => _AddActivityFormWidgetState();
}

class _AddActivityFormWidgetState extends State<AddActivityFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedActivityType = 'planting';
  String _selectedCrop = 'rice';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _reminderTiming = 'day_before';

  final List<Map<String, String>> _activityTypes = [
    {'value': 'planting', 'label': 'Planting', 'icon': 'eco'},
    {'value': 'irrigation', 'label': 'Irrigation', 'icon': 'water_drop'},
    {
      'value': 'fertilization',
      'label': 'Fertilization',
      'icon': 'scatter_plot'
    },
    {'value': 'pest_control', 'label': 'Pest Control', 'icon': 'bug_report'},
    {'value': 'harvesting', 'label': 'Harvesting', 'icon': 'agriculture'},
    {'value': 'weeding', 'label': 'Weeding', 'icon': 'grass'},
  ];

  final List<String> _crops = [
    'Rice',
    'Wheat',
    'Corn',
    'Tomato',
    'Potato',
    'Cotton'
  ];

  final List<Map<String, String>> _reminderOptions = [
    {'value': 'day_before', 'label': 'Day before'},
    {'value': 'morning_of', 'label': 'Morning of'},
    {'value': '2_hours_before', 'label': '2 hours before'},
    {'value': '1_hour_before', 'label': '1 hour before'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Activity',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Activity Type Selection
              Text(
                'Activity Type',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: _activityTypes.map((type) {
                  final isSelected = _selectedActivityType == type['value'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedActivityType = type['value']!),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(6.w),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : theme.colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: type['icon']!,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            type['label']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 3.h),

              // Activity Name
              Text(
                'Activity Name',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter activity name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter activity name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),

              // Crop Selection
              Text(
                'Crop',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                decoration: const InputDecoration(
                  hintText: 'Select crop',
                ),
                items: _crops.map((crop) {
                  return DropdownMenuItem(
                    value: crop.toLowerCase(),
                    child: Text(crop),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCrop = value!),
              ),
              SizedBox(height: 2.h),

              // Date and Time Selection
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: theme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'calendar_today',
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 5.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: _selectTime,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: theme.colorScheme.outline),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'access_time',
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 5.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  _selectedTime.format(context),
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Reminder Settings
              Text(
                'Reminder',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: _reminderTiming,
                decoration: const InputDecoration(
                  hintText: 'Select reminder timing',
                ),
                items: _reminderOptions.map((option) {
                  return DropdownMenuItem(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _reminderTiming = value!),
              ),
              SizedBox(height: 2.h),

              // Description
              Text(
                'Description (Optional)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add notes or description',
                ),
              ),
              SizedBox(height: 4.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveActivity,
                      child: const Text('Add Activity'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveActivity() {
    if (_formKey.currentState!.validate()) {
      final activity = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text,
        'type': _selectedActivityType,
        'crop': _selectedCrop,
        'date': _selectedDate,
        'time': _selectedTime.format(context),
        'reminderTiming': _reminderTiming,
        'description': _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        'isCompleted': false,
        'weatherSuitable': true,
        'resources': _getRequiredResources(_selectedActivityType),
      };

      widget.onActivityAdded(activity);
    }
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
}
