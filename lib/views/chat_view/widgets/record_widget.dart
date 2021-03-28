import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/controllers/chat_view_controllers/audio_recording_controller.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_controller.dart';

class RecordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AudioRecordingController>(
        create: (context) => AudioRecordingController(
          chatController: Provider.of<ChatController>(
            context,
            listen: false,
          ),
        ),
        child: Consumer<AudioRecordingController>(
          builder: (context, controller, child) => RaisedButton(
            child: Text(
              controller.currentState.isRecording ? 'Stop Recording' : 'Start Recording',
            ),
            onPressed: () {
              print('Recording state ${controller.currentState.isRecording}');
              if (controller.currentState.isRecording) {
                controller.stopRecording();
              } else {
                controller.startRecording();
              }
            },
          ),
        ),
      );
}
