import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madlifynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  Future<UserCredential> login(String email, String password) async {
    final completer = Completer<UserCredential>();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      completer.complete(userCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          completer.completeError("User not found");
        case "wrong-password":
          completer.completeError("Wrong password");
        default:
          completer.completeError("An error has occurred");
      }
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _email,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              hintText: "Enter your email address"),
                        ),
                        TextField(
                          controller: _password,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Enter your password"),
                        ),
                        TextButton(
                            onPressed: () async {
                              final user =
                                  await login(_email.text, _password.text);

                              print(user);
                            },
                            child: const Text("Login"))
                      ],
                    ));
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}
