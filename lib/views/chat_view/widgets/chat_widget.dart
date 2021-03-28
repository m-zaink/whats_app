import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_controller.dart';
import 'package:whats_app/views/chat_view/widgets/audio_message_widget.dart';

class ChatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<ChatController>(
        builder: (context, controller, message) => controller.currentState.messages.isEmpty
            ? _buildNoMessagesWidget(
                context,
                controller: controller,
              )
            : ListView.builder(
                itemBuilder: (context, index) => _buildChatWidget(
                  context,
                  index: index,
                  controller: controller,
                ),
                itemCount: controller.currentState.messages.length,
              ),
      );

  Widget _buildNoMessagesWidget(BuildContext context, {@required ChatController controller}) => Center(
        child: Text('Nothing to show here!'),
      );

  Widget _buildChatWidget(
    BuildContext context, {
    @required int index,
    @required ChatController controller,
  }) =>
      AudioMessageWidget(
        recordedAudioMessage: controller.currentState.messages[index],
      );
}
