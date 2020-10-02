import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
          stream: Firestore.instance
              .collection('chats/czM1sKhTsV9z4MCQHx7K/messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, messagesSnapshot) {
            if (messagesSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = messagesSnapshot.data.documents;
            return ListView.builder(
                reverse: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    key: ValueKey(documents[index].documentID),
                    message: documents[index]['text'],
                    owner: documents[index]['userId'] == userSnapshot.data.uid
                        ? MessageOwner.Self
                        : MessageOwner.Other,
                    userId: documents[index]['userId'],
                  );
                });
          },
        );
      },
    );
  }
}
