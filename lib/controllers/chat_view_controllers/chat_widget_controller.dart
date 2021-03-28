import 'package:flutter/foundation.dart';
import 'package:whats_app/models/messages/message.dart';

class ChatState {
  final List<Message> messages;

  ChatState({this.messages = const []});

  ChatState copyWith({List<Message> messages}) {
    return ChatState(
      messages: messages ?? this.messages,
    );
  }
}

abstract class ChatWidgetController extends ChangeNotifier {
  ChatState get currentState;

  factory ChatWidgetController() => _ChatWidgetControllerImpl();

  void addMessage(Message message);

  void removeMessage(Message message);
}

class _ChatWidgetControllerImpl extends ChangeNotifier
    implements ChatWidgetController {
  @override
  ChatState currentState;

  _ChatWidgetControllerImpl() : this.currentState = ChatState();

  @override
  void addMessage(Message message) {
    assert(message != null, 'Message cannot be null');

    updateState(
      currentState.copyWith(messages: [...currentState.messages, message]),
    );
  }

  @override
  void removeMessage(Message message) {
    // TODO: implement removeMessage
  }

  void updateState(ChatState updatedState) {
    currentState = updatedState;

    _notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}
