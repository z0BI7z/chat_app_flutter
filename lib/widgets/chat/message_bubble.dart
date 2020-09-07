import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageOwner { Self, Other }

class MessageBubble extends StatelessWidget {
  final MessageOwner owner;
  final String message;
  final String userId;

  MessageBubble({
    Key key,
    @required this.message,
    @required this.owner,
    @required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: Firestore.instance.collection('users').document(userId).get(),
      builder: (context, snapshot) {
        String text;
        String imageUrl;

        if (snapshot.connectionState == ConnectionState.waiting) {
          text = '...';
          imageUrl = '';
        } else {
          if (snapshot.data.exists) {
            text = snapshot.data['username'];
            imageUrl = snapshot.data['imageUrl'];
          } else {
            text = 'unknown';
            imageUrl = '';
          }
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            mainAxisAlignment: owner == MessageOwner.Self
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              ),
              Column(
                crossAxisAlignment: owner == MessageOwner.Self
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: width * .8),
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: owner == MessageOwner.Self
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: owner == MessageOwner.Self
                            ? Theme.of(context).primaryTextTheme.headline6.color
                            : Theme.of(context).accentTextTheme.headline6.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
