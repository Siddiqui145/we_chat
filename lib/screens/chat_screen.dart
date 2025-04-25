import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/chat_message.dart';
import 'package:we_chat/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
        actions: [
          IconButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, icon: Icon(
            Icons.exit_to_app,
            color: Theme.of(context).colorScheme.primary,))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessage()),
          NewMessage()
        ],
      ),
    );
  }
}