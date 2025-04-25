import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    messageController.dispose();
  }

  void submit() async {
    final enteredMessage = messageController.text;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userData = await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (enteredMessage.trim().isEmpty){
      return;
    }

    messageController.clear();
    FocusScope.of(context).unfocus(); //keyboard close

    FirebaseFirestore.instance.collection("chat").add({
      "text": enteredMessage,
      "createdAt": Timestamp.now(),
      "uid": userId,
      "username": userData.data()!['username'],
      "userimage": userData.data()!['image_url'],
    });


  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14
      ),
      child: Row(
        children: [
          Expanded(child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            controller: messageController,
            decoration: InputDecoration(
              labelText: "Send a Message"
            ),
          )),
          IconButton(
          onPressed: submit,
          icon: Icon(Icons.send),
          color: Theme.of(context).colorScheme.primary,)
        ],
      ),
    );
  }
}