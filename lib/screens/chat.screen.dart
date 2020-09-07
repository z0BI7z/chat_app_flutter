import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(8.0),
        child: Text('Item'),
      ),
    );
  }
}
