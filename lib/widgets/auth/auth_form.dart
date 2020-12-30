import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function({
    @required String email,
    @required String password,
    String username,
    File imageFile,
    @required bool isLogin,
  }) onSubmit;
  final bool isLoading;

  AuthForm({
    @required this.onSubmit,
    this.isLoading = false,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _username = '';
  String _password = '';
  File _imageFile;

  Future<void> _selectImage({File imageFile}) async {
    _imageFile = imageFile;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();

    if (!_isLogin && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid image'),
        ),
      );
      return;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid field(s)'),
        ),
      );
      return;
    }

    _formKey.currentState.save();

    widget.onSubmit(
      email: _email,
      password: _password,
      username: _username,
      imageFile: _imageFile,
      isLogin: _isLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      onSelect: _selectImage,
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    initialValue: DotEnv().env['FLUTTER_ENV'] == 'development'
                        ? 'a@b.com'
                        : '',
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      initialValue: DotEnv().env['FLUTTER_ENV'] == 'development'
                          ? 'slkdf'
                          : '',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Invalid username';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _username = newValue;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    initialValue: DotEnv().env['FLUTTER_ENV'] == 'development'
                        ? 'testing'
                        : '',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _password = newValue;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: _submit,
                        ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin
                        ? 'Create an account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
