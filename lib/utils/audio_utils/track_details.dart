import 'package:meta/meta.dart';

class TrackDetails {
  final String url;

  TrackDetails({
    @required this.url,
  }) : assert(url != null || url.isNotEmpty, 'Url cannot be null or empty');
}
