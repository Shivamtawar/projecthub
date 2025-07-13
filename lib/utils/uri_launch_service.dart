import 'package:url_launcher/url_launcher.dart';

class UriLaunchService {
  static canLaunchUrlApp(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> launchUrlApp(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
