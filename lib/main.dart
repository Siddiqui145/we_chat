import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/firebase_options.dart';
import 'package:we_chat/screens/auth_screen.dart';
import 'package:we_chat/screens/chat_screen.dart';
import 'package:we_chat/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter We-Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 118, 99, 78)),
      ),
      // A Better option for continuous check & can allow for check with login activity
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const SplashScreen();
          }

          if (snapshot.hasData){
            return const ChatScreen();
          }
          return const AuthScreen();
        }
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}