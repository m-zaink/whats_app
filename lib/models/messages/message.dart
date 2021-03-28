import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class Message {
  final String id;
  final DateTime creationDateTime;

  Message({
    String id,
    @required this.creationDateTime,
  })  : assert(creationDateTime != null, 'creationDateTime cannot be null'),
        this.id = id ?? Uuid().v4();
}
