import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madlifynotes/firebase_options.dart';
import 'package:madlifynotes/views/login_view.dart';
import 'package:madlifynotes/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madlify Note',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        "/login/": (context) => const LoginView(),
        "/register/": (context) => const RegisterView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified ?? false) {
            //   return const Padding(
            //     padding: EdgeInsets.all(12.0),
            //     child: Column(children: [Text("Done")]),
            //   );
            // } else {
            //   return const VerifyEmailView();
            // }
            return const LoginView();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
