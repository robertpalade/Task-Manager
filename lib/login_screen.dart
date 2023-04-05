import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_list_view.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // Navigate to the home screen after successful sign-in
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyListView(),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User not found')));
                  } else if (e.code == 'wrong-password') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                        Text('Incorrect password')));
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
