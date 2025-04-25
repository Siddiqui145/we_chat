import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/message_bubble.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chat").orderBy("createdAt",descending: true).snapshots(), 
      builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }

      if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
        return Center(child: Text("No Messages yet!"),);
      }

      if(snapshot.hasError){
        return Center(child: Text("Something went wrong!"),);
      }

      final loadedMessages = snapshot.data!.docs;

      return ListView.builder(
        padding: EdgeInsets.only(
          bottom: 40,
          left: 13,
          right: 13
        ),
        reverse: true, //instead of top to bottom it's bottom to top
        itemCount: loadedMessages.length,
        itemBuilder: (context, index) {

          final chatMessage = loadedMessages[index].data();
          final nextChatMessage = index + 1 <loadedMessages.length 
          ? loadedMessages[index+1].data() //shows that this isn't a first message
          : null;

          final currentMessageUserId = chatMessage['uid'];
          final nextMessageUserId = 
          nextChatMessage != null 
          ? nextChatMessage['uid']
          : null;

          final nextUserIsSame = nextMessageUserId == currentMessageUserId;

          if (nextUserIsSame){  // if same user is sending messages again
            return MessageBubble.next(
              message: chatMessage['text'], 
              isMe: user.uid == currentMessageUserId);
          }
          else{
            return MessageBubble.first(
              userImage: chatMessage['userimage'], 
              username: chatMessage['username'], 
              message: chatMessage['text'], 
              isMe: user.uid == currentMessageUserId);
          }
      },);
    },);
  }
}