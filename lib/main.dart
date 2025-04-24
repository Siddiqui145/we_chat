import 'package:flutter/material.dart';
import 'package:we_chat/screens/auth_screen.dart';

void main() {
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
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}