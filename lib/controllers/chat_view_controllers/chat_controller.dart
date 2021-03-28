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

abstract class ChatController extends ChangeNotifier {
  ChatState get currentState;

  factory ChatController() => _ChatControllerImpl();

  void addMessage(Message message);

  void removeMessage(Message message);
}

class _ChatControllerImpl extends ChangeNotifier implements ChatController {
  @override
  ChatState currentState;

  _ChatControllerImpl() : this.currentState = ChatState();

  @override
  void addMessage(Message message) {
    assert(message != null, 'Message cannot be null');

    updateState(
      currentState.copyWith(messages: [...currentState.messages, message]),
    );
  }

  @override
  void removeMessage(Message message) {
    assert(message != null, 'Message cannot be null');

    updateState(
      currentState.copyWith(
        messages: [
          ...currentState.messages
            ..removeWhere(
              (oldMessage) => message.id == oldMessage.id,
            )
        ],
      ),
    );
  }

  void updateState(ChatState updatedState) {
    currentState = updatedState;

    _notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}
