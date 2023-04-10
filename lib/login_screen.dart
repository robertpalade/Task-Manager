import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/register_screen.dart';

import 'my_list_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    emailController.text = "robert@robert.com";
    passwordController.text = "111111";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  //TODO
                  //Refactor
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // Navigate to the dashboard after successful sign-in
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyListView(),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Invalid username or email')));
                  } else if (e.code == 'wrong-password') {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Incorrect password')));
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? '),
                TextButton(
                  onPressed: () {
                    // Navigate to RegistrationScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
