import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/widgets/user_image_picker_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  var _enteredEmail = '';
  var _enteredPassword = '';

  final firebase = FirebaseAuth.instance;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid){
      return;
    }
    _formKey.currentState!.save();

    if(_isLogin){
      try{
        await firebase.signInWithEmailAndPassword(
          email: _enteredEmail, 
          password: _enteredPassword);
      }
      on FirebaseAuthException catch(err){
        if(!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message ?? "Failed Logging in User!")));
      }
    }

    else{
      try{
      await firebase.createUserWithEmailAndPassword(
        email: _enteredEmail , 
        password: _enteredPassword);
    }on FirebaseAuthException catch(err) {
      if(!mounted) return;

      if (err.code == "email-already-in-use"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message ?? "Email Already in use!")));
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message ?? "Authentication Failed!")));
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
                        UserImagePickerWidget(),
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
                        ElevatedButton(onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer
                        ),
                         child: Text(_isLogin ? 'Login' : 'Signup')),

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