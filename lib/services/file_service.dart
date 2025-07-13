import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/services/app_local_permission_service.dart';
import 'package:projecthub/controller/notification_controller.dart';
import 'package:projecthub/model/creation_model.dart';

class FileServices {
  static Future<void> downloadZipFile(Creation creation) async {
    final NotificationController _notificationController =
        NotificationController();
    final AppLocalPermissionService _appPermissionController =
        AppLocalPermissionService();
    if (await _appPermissionController.requestStoragePermission()) {
      try {
        var response = await http.Client().send(http.Request(
            'GET', Uri.parse(ApiConfig.getFileUrl(creation.creationFile!))));

        if (response.statusCode == 200) {
          var downloadsDirectory = await getDownloadsDirectory();
          var filePath =
              '${downloadsDirectory!.path}/${(creation.creationTitle)!.replaceAll(" ", "_")}.zip';
          var file = File(filePath);
          var bytes = <int>[];
          var total = response.contentLength ?? 1;
          var received = 0;

          response.stream.listen(
            (chunk) {
              log("1");
              bytes.addAll(chunk);
              received += chunk.length;
              var progress = ((received / total) * 100).toInt();
              _notificationController.showProgressNotification(progress);
            },
            onDone: () async {
              await file.writeAsBytes(bytes);
              _notificationController.flutterLocalNotificationsPlugin
                  .cancel(0); // Cancel the notification once done
              log('File downloaded to $filePath');
            },
            onError: (e) {
              log('Error in file download: $e');
              _notificationController.flutterLocalNotificationsPlugin.cancel(0);
            },
            cancelOnError: true,
          );
        } else {
          log('Failed to download file. Status code: ${response.statusCode}');
        }
      } catch (e) {
        log('Error: $e');
      }
    }
  }

  static Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      Get.snackbar("Not working for IOS", "contact developer");
    }
    return null;
  }

  static Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<File?> pickZipFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['zip']);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
