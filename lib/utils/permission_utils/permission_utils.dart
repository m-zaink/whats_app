import 'package:permission_handler/permission_handler.dart';

Future<bool> requestMicrophonePermission() async {
  final permissionStatus = await Permission.microphone.request();

  return permissionStatus == PermissionStatus.granted;
}

Future<bool> isMicrophonePermissionGranted() async {
  return await Permission.microphone.isGranted;
}

Future<bool> isMicrophonePermissionUndeterminedOrDenied() async {
  return await Permission.microphone.isDenied || await Permission.microphone.isUndetermined;
}

Future<bool> isMicrophonePermissionPermanentlyDenied() async {
  return await Permission.microphone.isPermanentlyDenied;
}
