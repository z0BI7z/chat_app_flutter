import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Function _createSubmit(BuildContext context) {
    return ({
      @required String email,
      @required String password,
      String username,
      File imageFile,
      @required bool isLogin,
    }) async {
      try {
        setState(() {
          _isLoading = true;
        });

        UserCredential authResult;
        if (isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(authResult.user.uid + '.jpg');
          await ref.putFile(imageFile);
          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'username': username,
            'email': email,
            'imageUrl': url,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      } on PlatformException catch (error) {
        var message = 'An error occurred. Please check your credentials.';
        if (error.message != null) {
          message = error.message;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(
        builder: (context) => AuthForm(
          isLoading: _isLoading,
          onSubmit: _createSubmit(context),
        ),
      ),
    );
  }
}
