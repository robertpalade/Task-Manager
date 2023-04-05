import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/login_screen.dart';

import 'my_list_view.dart';

class RegisterScreen extends StatelessWidget {
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
                hintText: 'Enter Email',
              ),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  // Get the newly created user's ID
                  String userId = userCredential.user!.uid;

                  // Get a Firebase Realtime Database reference to the user's data
                  DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$userId');

                  // Store the user's data in the database
                  await userRef.set({
                    'email': email,
                    'password': password,
                    // Add any other user data you want to store here
                  });

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('User registered successfully')));


                  // Registration successful, navigate to the home screen
                  // or display a success message to the user

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    // Handle weak password error
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('The password provided is too weak')));
                  } else if (e.code == 'email-already-in-use') {
                    // Handle email already in use error
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('An account with this email already exists')));
                  } else {
                    // Handle other errors
                  }
                } catch (e) {
                  // Handle other errors
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to RegistrationScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
