import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/crop_filter_chips.dart';
import './widgets/crop_search_bar.dart';
import './widgets/my_crop_card.dart';
import './widgets/recommended_crop_card.dart';
import 'widgets/crop_filter_chips.dart';
import 'widgets/crop_search_bar.dart';
import 'widgets/my_crop_card.dart';
import 'widgets/recommended_crop_card.dart';

class CropSelectionAndManagement extends StatefulWidget {
  const CropSelectionAndManagement({super.key});

  @override
  State<CropSelectionAndManagement> createState() =>
      _CropSelectionAndManagementState();
}

class _CropSelectionAndManagementState extends State<CropSelectionAndManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Cereals',
    'Pulses',
    'Vegetables',
    'Cash Crops',
  ];

  // Mock data for recommended crops
  final List<Map<String, dynamic>> _recommendedCrops = [
    {
      "id": 1,
      "name": "Basmati Rice",
      "localName": "बासमती चावल",
      "image":
          "https://images.pexels.com/photos/33239/rice-terraces-paddy-field-agriculture.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Cereals",
      "suitabilityScore": 85,
      "expectedYield": "4.5 tons/hectare",
      "marketDemand": "High",
      "season": "Kharif",
      "duration": "120-130 days"
    },
    {
      "id": 2,
      "name": "Tomato",
      "localName": "टमाटर",
      "image":
          "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Vegetables",
      "suitabilityScore": 92,
      "expectedYield": "25-30 tons/hectare",
      "marketDemand": "High",
      "season": "Rabi",
      "duration": "90-120 days"
    },
    {
      "id": 3,
      "name": "Cotton",
      "localName": "कपास",
      "image":
          "https://images.pexels.com/photos/6129507/pexels-photo-6129507.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Cash Crops",
      "suitabilityScore": 78,
      "expectedYield": "15-20 quintals/hectare",
      "marketDemand": "Medium",
      "season": "Kharif",
      "duration": "180-200 days"
    },
    {
      "id": 4,
      "name": "Chickpea",
      "localName": "चना",
      "image":
          "https://images.pexels.com/photos/4750270/pexels-photo-4750270.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Pulses",
      "suitabilityScore": 88,
      "expectedYield": "12-15 quintals/hectare",
      "marketDemand": "High",
      "season": "Rabi",
      "duration": "90-120 days"
    },
    {
      "id": 5,
      "name": "Wheat",
      "localName": "गेहूं",
      "image":
          "https://images.pexels.com/photos/326082/pexels-photo-326082.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Cereals",
      "suitabilityScore": 90,
      "expectedYield": "35-40 quintals/hectare",
      "marketDemand": "High",
      "season": "Rabi",
      "duration": "120-150 days"
    },
    {
      "id": 6,
      "name": "Onion",
      "localName": "प्याज",
      "image":
          "https://images.pexels.com/photos/144248/onions-food-vegetables-healthy-144248.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "category": "Vegetables",
      "suitabilityScore": 82,
      "expectedYield": "20-25 tons/hectare",
      "marketDemand": "Medium",
      "season": "Rabi",
      "duration": "120-150 days"
    }
  ];

  // Mock data for my crops
  final List<Map<String, dynamic>> _myCrops = [
    {
      "id": 1,
      "name": "Tomato",
      "image":
          "https://images.pexels.com/photos/1327838/pexels-photo-1327838.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "plantedDate": "15 Jan 2025",
      "growthStage": "Growing",
      "progress": 65,
      "nextAction": "Apply fertilizer in 3 days",
      "variety": "Hybrid F1",
      "area": "0.5 hectare"
    },
    {
      "id": 2,
      "name": "Wheat",
      "image":
          "https://images.pexels.com/photos/326082/pexels-photo-326082.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "plantedDate": "20 Nov 2024",
      "growthStage": "Flowering",
      "progress": 80,
      "nextAction": "Monitor for pests",
      "variety": "HD-2967",
      "area": "2 hectares"
    },
    {
      "id": 3,
      "name": "Chickpea",
      "image":
          "https://images.pexels.com/photos/4750270/pexels-photo-4750270.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "plantedDate": "10 Dec 2024",
      "growthStage": "Planting",
      "progress": 25,
      "nextAction": "First irrigation due",
      "variety": "Kabuli",
      "area": "1 hectare"
    }
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

  List<Map<String, dynamic>> get _filteredCrops {
    return _recommendedCrops.where((crop) {
      final matchesSearch = crop['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (crop['localName'] as String? ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || crop['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    // For now, show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Voice search feature coming soon!',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onCropTap(Map<String, dynamic> crop) {
    _showCropDetails(crop);
  }

  void _onAddCrop(Map<String, dynamic> crop) {
    // Add crop to my crops list
    setState(() {
      _myCrops.add({
        "id": _myCrops.length + 1,
        "name": crop['name'],
        "image": crop['image'],
        "plantedDate": "Today",
        "growthStage": "Planting",
        "progress": 0,
        "nextAction": "Prepare soil and plant seeds",
        "variety": "Standard",
        "area": "1 hectare"
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${crop['name']} added to your crops!',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        action: SnackBarAction(
          label: 'View',
          textColor: AppTheme.lightTheme.colorScheme.onPrimary,
          onPressed: () {
            _tabController.animateTo(1);
          },
        ),
      ),
    );
  }

  void _showCropDetails(Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Crop image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                          imageUrl: crop['image'] as String,
                          width: double.infinity,
                          height: 25.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Crop name and local name
                      Text(
                        crop['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),

                      if (crop['localName'] != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          crop['localName'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],

                      SizedBox(height: 3.h),

                      // Crop details grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 4.w,
                        mainAxisSpacing: 2.h,
                        children: [
                          _buildDetailCard(
                              'Suitability', '${crop['suitabilityScore']}%'),
                          _buildDetailCard('Expected Yield',
                              crop['expectedYield'] as String),
                          _buildDetailCard(
                              'Market Demand', crop['marketDemand'] as String),
                          _buildDetailCard('Season', crop['season'] as String),
                          _buildDetailCard(
                              'Duration', crop['duration'] as String),
                          _buildDetailCard(
                              'Category', crop['category'] as String),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Add to my crops button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _onAddCrop(crop);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            foregroundColor:
                                AppTheme.lightTheme.colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Add to My Crops',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // My Crops tab actions
  void _onMyCropTap(Map<String, dynamic> crop) {
    // Navigate to crop details or management screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening ${crop['name']} details...',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onUpdateStatus(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Update status for ${crop['name']}',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onSetReminder(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Setting reminder for ${crop['name']}',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _onViewCalendar(Map<String, dynamic> crop) {
    Navigator.pushNamed(context, '/farming-calendar-and-reminders');
  }

  void _onRemoveCrop(Map<String, dynamic> crop) {
    setState(() {
      _myCrops.removeWhere((c) => c['id'] == crop['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${crop['name']} removed from your crops',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _onEditCrop(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit details for ${crop['name']}',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onShareCrop(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing ${crop['name']} with community',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onConsultExpert(Map<String, dynamic> crop) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Consulting expert for ${crop['name']}',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        title: Text(
          'Crop Management',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/farmer-dashboard');
            },
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: AppTheme.lightTheme.colorScheme.onPrimary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Recommended'),
            Tab(text: 'My Crops'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Recommended Crops Tab
            Column(
              children: [
                // Search Bar
                CropSearchBar(
                  onSearchChanged: _onSearchChanged,
                  onVoiceSearch: _onVoiceSearch,
                ),

                // Filter Chips
                CropFilterChips(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _onCategorySelected,
                ),

                // Recommended Crops List
                Expanded(
                  child: _filteredCrops.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                size: 64,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No crops found',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _filteredCrops.length,
                          itemBuilder: (context, index) {
                            final crop = _filteredCrops[index];
                            return RecommendedCropCard(
                              crop: crop,
                              onTap: () => _onCropTap(crop),
                              onAdd: () => _onAddCrop(crop),
                            );
                          },
                        ),
                ),
              ],
            ),

            // My Crops Tab
            _myCrops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'agriculture',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No crops added yet',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Add crops from the recommended list',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                          onPressed: () => _tabController.animateTo(0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            foregroundColor:
                                AppTheme.lightTheme.colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Browse Crops',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 2.h),
                    itemCount: _myCrops.length,
                    itemBuilder: (context, index) {
                      final crop = _myCrops[index];
                      return MyCropCard(
                        crop: crop,
                        onTap: () => _onMyCropTap(crop),
                        onUpdateStatus: () => _onUpdateStatus(crop),
                        onSetReminder: () => _onSetReminder(crop),
                        onViewCalendar: () => _onViewCalendar(crop),
                        onRemove: () => _onRemoveCrop(crop),
                        onEdit: () => _onEditCrop(crop),
                        onShare: () => _onShareCrop(crop),
                        onConsult: () => _onConsultExpert(crop),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () => _tabController.animateTo(0),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            )
          : null,
    );
  }
}