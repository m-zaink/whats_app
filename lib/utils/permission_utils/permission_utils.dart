import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicrophonePermission() async {
  final permissionStatus = await Permission.microphone.request();

  return permissionStatus == PermissionStatus.granted;
}
