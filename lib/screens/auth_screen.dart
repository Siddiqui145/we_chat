import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/user_image_picker_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  File? _selectedImage; //For storing & using the passed picked File
  var _isAuthenticating = false;
  var _enteredName = '';

  final firebase = FirebaseAuth.instance;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null){
      return;
    }

    _formKey.currentState!.save();

    if(_isLogin){

      try{
        setState(() {
          _isAuthenticating = true;
        });
        await firebase.signInWithEmailAndPassword(
          email: _enteredEmail, 
          password: _enteredPassword);
      }
      on FirebaseAuthException catch(err){
        if(!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message ?? "Failed Logging in User!")));

        setState(() {
      _isAuthenticating = false;
    });
      }
    }

    else{
      try {
  setState(() {
    _isAuthenticating = true;
  });

  final userCredentials = await firebase.createUserWithEmailAndPassword(
    email: _enteredEmail,
    password: _enteredPassword,
  );

  //child child would just create folder inside folder, using ref
  final storageRef = FirebaseStorage.instance
      .ref()
      .child("User_Images")
      .child("${userCredentials.user!.uid}.jpg");

  // Try-catch around upload & getDownloadURL
  late final String imageUrl;  //putFile actually saves our image
  try {
    final uploadTask = await storageRef.putFile(_selectedImage!);
    imageUrl = await uploadTask.ref.getDownloadURL();
  } catch (e) {
    if (kDebugMode) print("Image upload failed: $e");

    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Image upload failed: $e")),
    );
    setState(() {
      _isAuthenticating = false;
    });
    return;
  }

  final uid = userCredentials.user!.uid;
  await FirebaseFirestore.instance.collection("users").doc(uid).set({
    "email": _enteredEmail,
    "image_url": imageUrl,
    "uid": uid,
    "username": _enteredName,
  });
} on FirebaseAuthException catch (err) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(err.message ?? "Authentication Failed!")),
  );

  setState(() {
    _isAuthenticating = false;
  });
}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
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
                        UserImagePickerWidget(
                          onPickImage: (pickedImage) {
                            _selectedImage = pickedImage;
                          },
                        ),
                        if (!_isLogin)
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "User Name",
                          ),
                          enableSuggestions: false,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty || value.trim().length < 4){
                              return 'Please enter a valid User Name';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredName = newValue!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email Address",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty || !value.contains('@')){
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty){
                              return 'Please enter a password';
                            }
                            if (value.trim().length < 6){
                              return 'Password must be at least 6 characters long!';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredPassword = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        if (_isAuthenticating) CircularProgressIndicator(),
                        
                        if(!_isAuthenticating)
                        ElevatedButton(onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer
                        ),
                         child: Text(_isLogin ? 'Login' : 'Signup')),

                        if (_isAuthenticating) CircularProgressIndicator(),

                        if(!_isAuthenticating)
                        TextButton(onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        }, 
                        child: Text(_isLogin ? 'Create an account' : 'Already have an account')),
                      ],
                  )),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}