import 'package:flutter/material.dart';
import 'package:whats_app/views/chat_view/chat_view.dart';

class WhatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: ChatView(),
      );
}
