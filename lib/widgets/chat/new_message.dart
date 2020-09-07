import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _message = '';

  get _isValid {
    return _message.trim().isNotEmpty;
  }

  Future<void> _send() async {
    final user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('chats/czM1sKhTsV9z4MCQHx7K/messages').add({
      'text': _message.trim(),
      'createdAt': Timestamp.now(),
      'userId': user.uid
    });

    _controller.clear();
    setState(() {
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                if (_isValid) {
                  _send();
                }
              },
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _isValid ? _send : null,
          ),
        ],
      ),
    );
  }
}
