import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/controllers/chat_view_controllers/chat_controller.dart';
import 'package:whats_app/views/chat_view/widgets/chat_widget.dart';
import 'package:whats_app/views/chat_view/widgets/record_widget.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<ChatController>(
        create: (context) => ChatController(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('WhatsApp'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ChatWidget(),
              ),
              RecordWidget(),
            ],
          ),
        ),
      );
}
