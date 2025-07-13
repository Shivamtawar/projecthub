import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projecthub/view/loading_screen/loading_screen.dart';

class PermissionRequestScreen extends StatefulWidget {
  final int userId;
  const PermissionRequestScreen({super.key, required this.userId});

  @override
  State<PermissionRequestScreen> createState() =>
      _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  final List<PermissionItem> _permissions = [
    PermissionItem(
      icon: Icons.notifications_active_rounded,
      title: "Notifications",
      description: "Get important updates and alerts about your projects",
      permission: Permission.notification,
      isRequired: false,
    ),
    PermissionItem(
      icon: Icons.location_on_rounded,
      title: "Location",
      description: "Essential for finding nearby resources and services",
      permission: Permission.location,
      isRequired: true, // Marked as required
    ),
    PermissionItem(
      icon: Icons.camera_alt_rounded,
      title: "Camera",
      description: "Scan documents and capture project progress photos",
      permission: Permission.camera,
      isRequired: false,
    ),
    // PermissionItem(
    //   icon: Icons.folder_rounded,
    //   title: "Storage",
    //   description: "Save and access your project files and documents",
    //   permission: Permission.storage,
    //   isRequired: false,
    // ),
  ];

  bool _isLoading = false;
  bool _showLocationWarning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text(
                "App Permissions",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "We need these permissions to provide full functionality",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.h),
              if (_showLocationWarning) _buildLocationWarning(),
              Expanded(
                child: ListView.separated(
                  itemCount: _permissions.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    return _PermissionCard(
                      icon: _permissions[index].icon,
                      title: _permissions[index].title,
                      description: _permissions[index].description,
                      isGranted: _permissions[index].isGranted,
                      isRequired: _permissions[index].isRequired,
                      onRequest: () => _requestPermission(index),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              _buildActionButtons(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationWarning() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Location permission is required to use this app",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.orange[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final locationPermission =
        _permissions.firstWhere((p) => p.permission == Permission.location);

    final bool canContinue = locationPermission.isGranted ||
        (!locationPermission.isGranted && !locationPermission.isRequired);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: _requestAllPermissions,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Allow All Recommended",
                    style: TextStyle(fontSize: 16.sp),
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: canContinue ? _continue : null,
            child: Text(
              "Continue",
              style: TextStyle(
                fontSize: 16.sp,
                color:
                    canContinue ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _requestPermission(int index) async {
    setState(() {
      _isLoading = true;
      _showLocationWarning = false;
    });

    final status = await _permissions[index].permission.request();
    _permissions[index].isGranted = status.isGranted;

    setState(() {
      _isLoading = false;
      // Show warning if location is required but not granted
      if (_permissions[index].isRequired && !_permissions[index].isGranted) {
        _showLocationWarning = true;
      }
    });
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isLoading = true;
      _showLocationWarning = false;
    });

    for (var permission in _permissions) {
      if (!permission.isGranted) {
        final status = await permission.permission.request();
        permission.isGranted = status.isGranted;
      }
    }

    setState(() {
      _isLoading = false;
      // Show warning if location is required but not granted
      final locationPermission =
          _permissions.firstWhere((p) => p.permission == Permission.location);
      if (locationPermission.isRequired && !locationPermission.isGranted) {
        _showLocationWarning = true;
      }
    });
  }

  void _continue() {
    final locationPermission =
        _permissions.firstWhere((p) => p.permission == Permission.location);

    if (locationPermission.isRequired && !locationPermission.isGranted) {
      // Show dialog explaining why location is needed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Permission Required"),
          content: const Text(
              "This app requires location permission to function properly. "
              "Please enable location access in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text("Open Settings"),
            ),
          ],
        ),
      );
      return;
    }

    // Only navigate if location is granted or not required
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => LoadingScreen(
                userId: widget.userId,
              )),
    );
  }
}

class PermissionItem {
  final IconData icon;
  final String title;
  final String description;
  final Permission permission;
  bool isGranted;
  final bool isRequired;

  PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.permission,
    this.isGranted = false,
    required this.isRequired,
  });
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final bool isRequired;
  final VoidCallback onRequest;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.isRequired,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isRequired
                    ? Colors.orange.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24.w,
                color:
                    isRequired ? Colors.orange : Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isRequired)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Text(
                            "Required",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            isGranted
                ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 24.w,
                  )
                : TextButton(
                    onPressed: onRequest,
                    child: Text(
                      "Allow",
                      style: TextStyle(
                        color: isRequired
                            ? Colors.orange
                            : Theme.of(context).primaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
