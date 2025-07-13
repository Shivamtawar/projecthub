import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:projecthub/app_providers/creation_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:projecthub/app_providers/data_file_provider.dart';
import 'package:projecthub/app_providers/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/controller/creation_controller.dart';
import 'package:projecthub/controller/files_controller.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:projecthub/model/creation_info_model.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class ListNewCreationScreen extends StatefulWidget {
  const ListNewCreationScreen({super.key});

  @override
  State<ListNewCreationScreen> createState() => _ListNewCreationScreenState();
}

class _ListNewCreationScreenState extends State<ListNewCreationScreen> {
  final TextEditingController _creationTitleController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _filePathController = TextEditingController();
  final FilesController _filesController = FilesController();
  final _infoFormKey = GlobalKey<FormState>();
  final _categoryInfoKey = GlobalKey<FormState>();
  List<CategoryModel> _categories = [];
  bool _showCategories = false;
  List<CategoryModel> _filteredCategories = [];
  String thumbnailErrorMassage = '';
  List<String> _keywords = [];
  bool _submitPressedOnce = false;
  File? _thumbnailImage;
  File? _sourceZipFile;
  List<String> _otherImages = [];
  bool _isUploading = false;
  ValueNotifier<double> _uploadProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();

    _filteredCategories = _categories;
    _categoryController.addListener(() {
      setState(() {
        _filteredCategories = _categories
            .where((category) => category.name!
                .toLowerCase()
                .contains(_categoryController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _creationTitleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _keywordController.dispose();
    _filePathController.dispose();
    super.dispose();
  }

  // Function to request permissions and pick an image
  Future<void> _pickImage() async {
    // Request permissions before picking the image
    final thumbnailFile = await _filesController.pickThumbnail();
    //PermissionStatus status = await Permission.photos.request();

    if (thumbnailFile != null) {
      setState(() {
        _thumbnailImage = thumbnailFile;
        thumbnailErrorMassage = "";
      });
    } else {
      Get.snackbar(
          "Thumbnail not selected", "Thumbanil selection was canceled");
    }
  }

  Future<void> pickZipFile() async {
    // Use file_picker to pick a ZIP file
    File? result = await _filesController.pickZipFile();
    if (result != null) {
      String filePath = result.path;

      if (filePath.endsWith('.zip')) {
        setState(() {
          _sourceZipFile = result;
          _filePathController.text =
              path.basename(filePath); // Extract file name
        });
      } else {
        setState(() {
          Get.snackbar("File not selected",
              "Invalid file type. Please select a ZIP file..");
          _filePathController.text = "";
        });
      }
    } else {
      // User canceled the picker
      Get.snackbar("File not selected", "File selection was canceled.");
    }
  }

  void _addKeyword(String keyword) {
    if (keyword.isNotEmpty && !_keywords.contains(keyword)) {
      setState(() {
        _keywords.add(keyword.trim());
      });
      _keywordController.clear();
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  Future<bool> _showSaveConfirmationDialog(BuildContext context) async {
    bool allowBAck = false;
    Get.defaultDialog(
      title: "Alert !",
      titleStyle: AppText.heddingStyle2bBlack,
      middleText: 'The information is not saved. Do you want to discard it?',
      textConfirm: '  Discard  ',
      textCancel: '  Cancel  ',
      onCancel: () {
        FocusScope.of(context).unfocus();
      },
      onConfirm: () {
        Get.back();
        Get.back();
        allowBAck = true;
      },
    );

    // Default to false if null
    return allowBAck;
  }

  onSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_thumbnailImage == null) {
        thumbnailErrorMassage = "Please select thumbnail";
      } else {
        thumbnailErrorMassage = "";
      }
      _submitPressedOnce = true;
      _isUploading = true;
    });

    bool isBasicInfoFilled = _infoFormKey.currentState!.validate();
    bool isCategorySelected = _categoryInfoKey.currentState!.validate();

    if (isBasicInfoFilled && isCategorySelected) {
      int userid = Provider.of<UserInfoProvider>(context, listen: false)
          .getUserInfo
          .userId;

      Map<String, dynamic> data = {
        'creation_title': _creationTitleController.text.trim(),
        'creation_description': _descriptionController.text.trim(),
        'creation_price': double.parse(_priceController.text.trim()),
        'creation_thumbnail': _thumbnailImage,
        'creation_file': _sourceZipFile,
        'category_id': 1,
        'keyword': _keywords,
        'otherImages': _otherImages,
        'user_id': userid,
      };

      NewCreationModel newCreation = NewCreationModel.fromJson(data);

      CreationController creationController = CreationController();
      showProgresPopUP();
      // Listen for progress updates
      await creationController.listCreation(newCreation, (double progress) {
        _uploadProgress.value = progress;
      }).then((statuscode) {
        Get.back(); // this will close progress pop up
        if (statuscode == 200) {
          showSuccefullPopUp();
          Provider.of<UserInfoProvider>(context, listen: false)
              .fetchUserDetails(
                  Provider.of<UserInfoProvider>(context, listen: false)
                      .user!
                      .userId);
        } else {
          showErrorPopUp();
        }
        setState(() {
          _isUploading = false;
          _uploadProgress.value = 0.0;
        });
      });
    }
  }

  showSuccefullPopUp() {
    Get.defaultDialog(
      onWillPop: () async {
        return false;
      },
      onConfirm: () {
        Provider.of<CreationProvider>(context, listen: false).fetchCreations(
            Provider.of<UserInfoProvider>(context, listen: false).user!.userId);

        Get.back();
        Get.back();
      },
      title: "Successful",
      titleStyle: AppText.appPrimaryText,
      middleText:
          "Your creation has been submitted for review. Once the status is updated, you will be notified.",
    );
  }

  showErrorPopUp() {
    Get.defaultDialog(
      title: "Uploading failed !",
      titleStyle: AppText.heddingStyle2bBlack,
      middleText: "creation not uploaded",
    );
  }

  showProgresPopUP() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Uploading ...",
      titleStyle: AppText.heddingStyle2bBlack,
      onWillPop: () async {
        return false;
      },
      content: Column(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _uploadProgress,
            builder: (context, progress, child) {
              return LinearProgressIndicator(value: progress);
            },
          )
        ],
      ),
    );
  }

  getData() {
    _categories = Provider.of<DataFileProvider>(context).categories;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return WillPopScope(
      onWillPop: () async {
        // Show the save confirmation dialog
        bool allowBAck = await _showSaveConfirmationDialog(context);
        if (allowBAck) {
          Get.back();
        }
        return allowBAck;

        // Allow or block navigation
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              alignment: Alignment.center,
              onPressed: () {
                _showSaveConfirmationDialog(context);
              },
              icon: AppIcon.backIcon),
          title: const Text("List new creation"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.edgePadding),
          child: ListView(
            children: [
              SizedBox(height: Get.height * 0.02),
              getThumbnailView(_thumbnailImage),
              SizedBox(height: Get.height * 0.04),
              getInformationForm(),
              SizedBox(height: Get.height * 0.04),
              _getCategoryForm(),
              SizedBox(height: Get.height * 0.02),
              _getSubmitButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaddinfText(String str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        //fontFamily: 'Gilroy',
      ),
    );
  }

  getThumbnailView(image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getHeaddinfText("Thumbnail *"),
        SizedBox(height: Get.height * 0.01),
        GestureDetector(
          onTap: _pickImage,
          child: (image != null)
              ? Container(
                  width: double.infinity, // Width of the container
                  height: 210.h,
                  decoration: BoxDecoration(
                    //color: AppColor.primaryColor,
                    image: DecorationImage(
                        image: FileImage(File(image.path)), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColor.primaryColor, width: 1.5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.edit)),
                      )
                    ],
                  ), // Height of the container
                )
              : DottedBorder(
                  color: AppColor.primaryColor, // Border color
                  strokeWidth: 2, // Border width
                  dashPattern: const [6, 4], // Dash and space pattern
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12), // Rounded corners
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 234, 237, 250),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity, // Width of the container
                    height: 200.h, // Height of the container
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Thumbnail',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        SizedBox(
          height: 10.h,
        ),
        if (thumbnailErrorMassage.isNotEmpty)
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Text(
                thumbnailErrorMassage,
                style: AppText.errorMassageTextStyle,
              ),
            ],
          ),
      ],
    );
  }

  getInformationForm() {
    return Form(
      key: _infoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Listing details",
            style: AppText.bigHeddingStyle1a,
          ),
          const Text(
            "Provide all the necessary information about your iterm to create an attractive listing and reach more buyers",
            style: TextStyle(fontSize: 11, color: Colors.black87),
          ),
          SizedBox(height: Get.height * 0.028),
          getHeaddinfText("Product name *"),
          SizedBox(height: Get.height * 0.01),
          _getInfoTextField(
              controller: _creationTitleController,
              title: "Product name",
              maxLength: 100),
          SizedBox(height: Get.height * 0.012),
          getHeaddinfText(
            "Description",
          ),
          SizedBox(height: Get.height * 0.01),
          _getInfoTextField(
              controller: _descriptionController,
              maxLines: 4,
              title: "Description",
              canNull: true,
              maxLength: 4000),
          SizedBox(height: Get.height * 0.012),
          getHeaddinfText("Price *"),
          SizedBox(
            height: Get.height * 0.01,
          ),
          _getInfoTextField(
            controller: _priceController,
            isNumeric: true,
            prfixIcon: const Text("₹"),
            title: "Price",
          ),
          SizedBox(height: Get.height * 0.028),
          getHeaddinfText("Select file *"),
          SizedBox(height: Get.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (Get.width - 2 * AppPadding.edgePadding) * 0.6,
                child: _getInfoTextField(
                  controller: _filePathController,
                  readOnly: true,
                  title: "File",
                  hintText: "No file selected",
                ),
              ),
              SizedBox(width: Get.width * 0.012),
              AppPrimaryButton(
                title: "Pick ZIP file",
                onPressed: () {
                  if (_submitPressedOnce) {
                    _infoFormKey.currentState!.validate();
                  }
                  pickZipFile();
                },
                icon: const Icon(
                  Icons.folder,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  bool isInteger(String str) {
    return int.tryParse(str) != null;
  }

  _getInfoTextField(
      {required TextEditingController controller,
      int? maxLines,
      Widget? prfixIcon,
      bool? isNumeric,
      bool? readOnly,
      required String title,
      bool canNull = false,
      String? hintText,
      int? maxLength}) {
    return TextFormField(
      onTapOutside: (p) {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      onChanged: (value) {
        if (_submitPressedOnce) {
          _infoFormKey.currentState!.validate();
        }
      },
      controller: controller,
      readOnly: (readOnly != null) ? readOnly : false,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType:
          (isNumeric != null && isNumeric) ? TextInputType.number : null,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: (prfixIcon != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prfixIcon,
                ],
              )
            : null,
        hintStyle: AppText.textFieldHintTextStyle,
        focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
        errorBorder: AppTextfieldBorder.errorBorder,
        focusedBorder: AppTextfieldBorder.focusedBorder,
        enabledBorder: AppTextfieldBorder.enabledBorder,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.only(
          left: 20.w,
          top: 10.h,
          bottom: 10.h,
          right: 20.w,
        ),
      ),
      validator: (value) {
        if (!canNull) {
          if (value != null && value.isEmpty) {
            return "$title should not empty";
          }
        }
        if (isNumeric != null &&
            isNumeric &&
            !isInteger(controller.text.trim())) {
          return "Please enter intiger value";
        }
        return null;
      },
    );
  }

  _getCategoryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category details",
          style: AppText.bigHeddingStyle1a,
        ),
        const Text(
          "Provide category details that helps others to find your creation easly",
          style: TextStyle(fontSize: 11, color: Colors.black87),
        ),
        SizedBox(height: Get.height * 0.028),
        getHeaddinfText("Category *"),
        SizedBox(height: Get.height * 0.01),
        Form(
          key: _categoryInfoKey,
          child: TextFormField(
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Please select category";
              }
              return null;
            },
            onTapOutside: (p) {
              setState(() {
                // _showCategories = false;
                // FocusScope.of(context).unfocus();
              });
            },
            onTap: () {
              setState(() {
                _showCategories = true;
              });
            },
            onChanged: (value) {
              setState(() {
                _showCategories = true;
              });
            },
            //readOnly: true,
            controller: _categoryController,
            decoration: InputDecoration(
                hintText: "--- Select ---",
                focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                errorBorder: AppTextfieldBorder.errorBorder,
                focusedBorder: AppTextfieldBorder.focusedBorder,
                enabledBorder: AppTextfieldBorder.enabledBorder,
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: EdgeInsets.only(
                  left: 20.w,
                  top: 10.h,
                  bottom: 10.h,
                  right: 20.w,
                ),
                suffixIcon: const Icon(Icons.arrow_drop_down)),
          ),
        ),
        if (_showCategories)
          Container(
            decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            height: Get.height * 0.35,
            child: ListView.builder(
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredCategories[index].name!),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _categoryController.text =
                          _filteredCategories[index].name!;
                      _showCategories = false;
                    });
                  },
                );
              },
            ),
          ),
        SizedBox(height: Get.height * 0.03),
        getHeaddinfText("Keywords"),
        const Text(
          "Please press enter while specifying multiple keyword. Keyword separated by comma or space will be considered as a single entity.",
          style: TextStyle(fontSize: 11, color: Colors.black87),
        ),
        SizedBox(height: Get.height * 0.01),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onTapOutside: (p) {
                _addKeyword(_keywordController.text);
                FocusScope.of(context).unfocus();
              },
              controller: _keywordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: EdgeInsets.only(
                  left: 20.w,
                  top: 10.h,
                  bottom: 10.h,
                  right: 20.w,
                ),
                hintText: 'Enter a keyword and press Enter',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),
                focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                errorBorder: AppTextfieldBorder.errorBorder,
                focusedBorder: AppTextfieldBorder.focusedBorder,
                enabledBorder: AppTextfieldBorder.enabledBorder,
              ),
              onSubmitted: _addKeyword,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0, // Space between tags horizontally
              runSpacing: 4.0, // Space between tags vertically
              children: _keywords.map((keyword) {
                return Chip(
                  label: Text(keyword),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeKeyword(keyword),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  _getSubmitButton() {
    return Row(
      children: [
        AppPrimaryButton(title: "Submit", onPressed: onSubmit),
      ],
    );
  }
}
