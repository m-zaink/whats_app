import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/controllers/chat_view_controllers/audio_playback_controller.dart';
import 'package:whats_app/models/messages/recorded_audio_message.dart';

class AudioMessageWidget extends StatelessWidget {
  final RecordedAudioMessage recordedAudioMessage;

  const AudioMessageWidget({
    Key key,
    @required this.recordedAudioMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AudioPlaybackController>(
        create: (context) => AudioPlaybackController(
          trackDetails: recordedAudioMessage.trackDetails,
        ),
        child: Consumer<AudioPlaybackController>(
          builder: (context, controller, child) => ListTile(
            title: Text(recordedAudioMessage.id),
            trailing: IconButton(
              icon: Icon(
                controller.currentState.isPlaying ? Icons.stop : Icons.play_arrow,
              ),
              onPressed: () {
                if (controller.currentState.isPlaying) {
                  _startPlayback(controller);
                } else {
                  _stopPlayback(controller);
                }
              },
            ),
          ),
        ),
      );

  void _startPlayback(AudioPlaybackController controller) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.stopPlaying();
    });
  }

  void _stopPlayback(AudioPlaybackController controller) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.startPlaying();
    });
  }
}
