import 'package:meta/meta.dart';
import 'package:whats_app/models/messages/message.dart';
import 'package:whats_app/utils/audio_utils/track_details.dart';

class RecordedAudioMessage extends Message {
  final TrackDetails trackDetails;

  RecordedAudioMessage({
    String id,
    @required this.trackDetails,
  })  : assert(trackDetails != null, 'trackDetails cannot be null'),
        super(id: id, creationDateTime: DateTime.now());
}
