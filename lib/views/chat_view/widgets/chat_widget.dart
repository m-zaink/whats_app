import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_controller.dart';
import 'package:whats_app/views/chat_view/widgets/audio_message_widget.dart';

class ChatWidget extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) => Consumer<ChatController>(
        builder: (context, controller, message) {
          if (controller.currentState.messages.isEmpty) {
            return Center(
              child: Text('Nothing to show here!'),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
              );
            });

            return ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) => AudioMessageWidget(
                recordedAudioMessage: controller.currentState.messages[index],
              ),
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                thickness: 1.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              itemCount: controller.currentState.messages.length,
            );
          }
        },
      );
}
