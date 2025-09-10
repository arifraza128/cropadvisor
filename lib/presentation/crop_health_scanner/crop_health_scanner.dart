
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/analysis_loading_widget.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/camera_focus_guide_widget.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/camera_tips_widget.dart';
import './widgets/capture_button_widget.dart';
import './widgets/image_preview_widget.dart';

class CropHealthScanner extends StatefulWidget {
  const CropHealthScanner({super.key});

  @override
  State<CropHealthScanner> createState() => _CropHealthScannerState();
}

class _CropHealthScannerState extends State<CropHealthScanner>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isTipsExpanded = false;
  bool _isProcessing = false;
  XFile? _capturedImage;
  String _currentScreen = 'camera'; // camera, preview, loading, results

  // Mock analysis data
  final List<Map<String, dynamic>> _mockAnalysisResults = [
    {
      "issue": "Leaf Blight Disease",
      "confidence": 0.89,
      "severity": "medium",
      "description":
          "Leaf blight is a common fungal disease that affects crop leaves, causing brown spots and yellowing. It typically occurs in humid conditions and can spread rapidly if not treated promptly. Early detection and treatment are crucial for preventing crop loss.",
      "treatments": [
        {
          "type": "organic",
          "name": "Neem Oil Spray",
          "description":
              "Apply neem oil solution (2-3ml per liter of water) during early morning or evening. Repeat every 7-10 days until symptoms improve.",
          "availability": "Available"
        },
        {
          "type": "chemical",
          "name": "Copper Fungicide",
          "description":
              "Use copper-based fungicide as per manufacturer's instructions. Ensure proper protective equipment during application.",
          "availability": "Check local stores"
        }
      ]
    },
    {
      "issue": "Nutrient Deficiency",
      "confidence": 0.76,
      "severity": "low",
      "description":
          "The yellowing pattern suggests nitrogen deficiency in the plant. This is common during rapid growth phases and can be easily corrected with proper fertilization.",
      "treatments": [
        {
          "type": "organic",
          "name": "Compost Application",
          "description":
              "Apply well-decomposed compost around the plant base. Water thoroughly after application.",
          "availability": "Available"
        },
        {
          "type": "chemical",
          "name": "NPK Fertilizer",
          "description":
              "Apply balanced NPK fertilizer (10:10:10) as per soil test recommendations.",
          "availability": "Available"
        }
      ]
    },
    {
      "issue": "Pest Infestation",
      "confidence": 0.92,
      "severity": "high",
      "description":
          "Signs of aphid infestation detected on leaf surfaces. These small insects can cause significant damage by sucking plant juices and transmitting viral diseases. Immediate action is recommended.",
      "treatments": [
        {
          "type": "organic",
          "name": "Soap Water Spray",
          "description":
              "Mix 2 tablespoons of mild soap in 1 liter water. Spray on affected areas, focusing on undersides of leaves.",
          "availability": "Available"
        },
        {
          "type": "chemical",
          "name": "Systemic Insecticide",
          "description":
              "Apply systemic insecticide following label instructions. Avoid application during flowering period.",
          "availability": "Available"
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        _showPermissionDialog();
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showCameraErrorDialog();
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      debugPrint('Settings error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      setState(() => _isFlashOn = !_isFlashOn);
      await _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() => _isProcessing = true);

      final XFile photo = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = photo;
        _currentScreen = 'preview';
        _isProcessing = false;
      });

      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Capture error: $e');
      setState(() => _isProcessing = false);
      _showErrorSnackBar('Failed to capture photo. Please try again.');
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _currentScreen = 'preview';
        });
      }
    } catch (e) {
      debugPrint('Gallery selection error: $e');
      _showErrorSnackBar('Failed to select image from gallery.');
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _currentScreen = 'camera';
    });
  }

  Future<void> _analyzeImage() async {
    if (_capturedImage == null) return;

    setState(() => _currentScreen = 'loading');

    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 6));

    // Randomly select a mock result
    final randomResult = (_mockAnalysisResults..shuffle()).first;

    setState(() => _currentScreen = 'results');
  }

  void _shareResults() {
    // Implement sharing functionality
    _showErrorSnackBar('Sharing feature will be available soon.');
  }

  void _startNewScan() {
    setState(() {
      _capturedImage = null;
      _currentScreen = 'camera';
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Permission Required',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Please grant camera permission to scan crop health.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'No Camera Found',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'No camera is available on this device.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Error',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Failed to initialize camera. Please try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case 'preview':
        return ImagePreviewWidget(
          imagePath: _capturedImage!.path,
          onRetake: _retakePhoto,
          onConfirm: _analyzeImage,
        );
      case 'loading':
        return AnalysisLoadingWidget(
          imagePath: _capturedImage!.path,
        );
      case 'results':
        return AnalysisResultsWidget(
          analysisResult: (_mockAnalysisResults..shuffle()).first,
          imagePath: _capturedImage!.path,
          onShare: _shareResults,
          onNewScan: _startNewScan,
        );
      default:
        return _buildCameraScreen();
    }
  }

  Widget _buildCameraScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          _isCameraInitialized && _cameraController != null
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_cameraController!),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Initializing camera...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          // Camera overlay (top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CameraOverlayWidget(
              onClose: () => Navigator.pop(context),
              onFlashToggle: _toggleFlash,
              isFlashOn: _isFlashOn,
              showFlash: !kIsWeb,
            ),
          ),

          // Focus guide (center)
          if (_isCameraInitialized)
            const Positioned.fill(
              child: CameraFocusGuideWidget(),
            ),

          // Tips bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CameraTipsWidget(
                  isExpanded: _isTipsExpanded,
                  onToggle: () =>
                      setState(() => _isTipsExpanded = !_isTipsExpanded),
                ),
                if (!_isTipsExpanded)
                  CaptureButtonWidget(
                    onCapture: _capturePhoto,
                    onGallery: _selectFromGallery,
                    isProcessing: _isProcessing,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
