import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _newMessageFocusNode = FocusNode();

  @override
  void dispose() {
    _newMessageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            dropdownColor: Theme.of(context).primaryIconTheme.color,
            onChanged: (value) {
              switch (value) {
                case 'logout':
                  {
                    FirebaseAuth.instance.signOut();
                  }
                  break;
                default:
                  {
                    return;
                  }
              }
            },
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanDown: (details) {
                  if (_newMessageFocusNode.hasFocus) {
                    _newMessageFocusNode.unfocus();
                  }
                },
                child: Messages(),
              ),
            ),
            NewMessage(
              focusNode: _newMessageFocusNode,
            ),
          ],
        ),
      ),
    );
  }
}
