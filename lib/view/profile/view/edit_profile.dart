import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_text.dart';
import 'dart:io';

import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/model/user_info_model.dart';
import 'package:projecthub/widgets/app_dailogbox.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  File? _profileImage;
  bool _isEdited = false; // Track if any changes are made
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user!.userName!;
    if (widget.user!.userEmail != null) {
      _emailController.text = widget.user!.userEmail!;
    }
    if (widget.user!.userDescription != null) {
      _descriptionController.text = widget.user!.userDescription!;
    }
    if (widget.user!.userContact != null) {
      _mobileNumberController.text = widget.user!.userContact!;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isEdited = true; // Mark as edited
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Save the profile details (you can add your logic here)
      final userProvider =
          Provider.of<UserInfoProvider>(context, listen: false);
      Map<String, dynamic> data = {};
      if (_nameController.text != widget.user!.userName) {
        data['user_name'] = _nameController.text.trim();
        userProvider.setUserName(_nameController.text.trim());
      }
      if (_descriptionController.text != widget.user!.userDescription) {
        data['user_description'] = _descriptionController.text.trim();
        userProvider.setDescription(_descriptionController.text.trim());
      }

      if (_mobileNumberController.text != widget.user!.userContact) {
        data['user_contact'] = _mobileNumberController.text.trim();
        userProvider.setMobileNumber(_mobileNumberController.text.trim());
      }
      if (_emailController.text != widget.user!.userEmail) {
        data['user_email'] = _emailController.text.trim();
        userProvider.setEmail(_emailController.text.trim());
      }
      if (_profileImage != null) {
        data['profile_photo'] = _profileImage!.path;
      }
      log(data.toString());
      showUpadteAlertBox();
      try {
        await userProvider.updateUser(widget.user!.userId, data);
        Get.back();
        Get.back();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully!')),
        );
      } catch (e) {
        Get.back();
        Get.back();
        Get.snackbar("$e", "");
      }

      setState(() {
        _isEdited = false; // Reset edited state after saving
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_isEdited) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
              'You have unsaved changes. Are you sure you want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.save),
          //     onPressed: _saveProfile,
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Profile Picture with Edit Icon
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (widget.user!.profilePhoto != null)
                                  ? NetworkImage(ApiConfig.baseURL +
                                      widget.user!.profilePhoto!)
                                  : null,
                          child: (_profileImage == null &&
                                  widget.user!.profilePhoto == null)
                              ? const Icon(Icons.camera_alt, size: 40)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: AppText.textFieldHintTextStyle,
                    focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                    errorBorder: AppTextfieldBorder.errorBorder,
                    focusedBorder: AppTextfieldBorder.focusedBorder,
                    enabledBorder: AppTextfieldBorder.enabledBorder,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding:
                        EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _isEdited = true; // Mark as edited
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  enabled: (widget.user!.loginType == 'google') ? false : true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: AppText.textFieldHintTextStyle,
                    focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                    errorBorder: AppTextfieldBorder.errorBorder,
                    focusedBorder: AppTextfieldBorder.focusedBorder,
                    enabledBorder: AppTextfieldBorder.enabledBorder,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding:
                        EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _isEdited = true; // Mark as edited
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Discription',
                    labelStyle: AppText.textFieldHintTextStyle,
                    focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                    errorBorder: AppTextfieldBorder.errorBorder,
                    focusedBorder: AppTextfieldBorder.focusedBorder,
                    enabledBorder: AppTextfieldBorder.enabledBorder,
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding:
                        EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                  ),
                  maxLines: 5,
                  maxLength: 250,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    if (value.split(' ').length > 250) {
                      return 'Description should not exceed 250 words';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _isEdited = true; // Mark as edited
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Mobile Number (Fixed)
                TextFormField(
                  initialValue: _mobileNumberController.text,
                  readOnly:
                      (widget.user!.loginType == 'mobile') ? false : false,
                  decoration: InputDecoration(
                    enabled:
                        (widget.user!.loginType == 'mobile') ? false : true,
                    labelText: 'Mobile Number',
                    labelStyle: AppText.textFieldHintTextStyle,
                    contentPadding:
                        EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button

                AppPrimaryElevetedButton(
                    onPressed: _isEdited ? _saveProfile : null,
                    title: "Save Profile")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
