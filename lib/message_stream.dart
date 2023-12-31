import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/message_bubbles.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //stream: _firestore.collection('messages').snapshots(),
       stream: _firestore
          .collection('messages')
          .orderBy(
            'timestamp',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data!.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          // final messageText = message.data()['text'];
          // final messageSender = message.data()['sender'];

          final messageText = message['text'];
          final messageSender = message['sender'];
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            //message gonna show from the bottom to top view instead of the other way
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
