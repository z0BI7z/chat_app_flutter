import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/chat.screen.dart';
import 'screens/auth.screen.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
