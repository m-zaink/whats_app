import 'package:meta/meta.dart';

abstract class Message {
  final DateTime creationDateTime;

  Message({@required this.creationDateTime})
      : assert(creationDateTime != null, 'creationDateTime cannot be null');
}
