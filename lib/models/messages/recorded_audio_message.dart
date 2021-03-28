import 'package:whats_app/models/messages/message.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';

class RecordedAudioMessage extends Message {
  final TrackDetails trackDetails;

  RecordedAudioMessage(this.trackDetails)
      : super(creationDateTime: DateTime.now());
}
