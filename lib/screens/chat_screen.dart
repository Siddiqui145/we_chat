import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/chat_message.dart';
import 'package:we_chat/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setupPushNoti() async{
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();  //final notificationSettings has various options further
    await fcm.getToken();
    //final token =     print(token); 
  }

  @override
  void initState(){
    super.initState();
    setupPushNoti();
  }

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