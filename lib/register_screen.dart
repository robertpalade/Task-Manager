import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/login_screen.dart';

import 'constants.dart';
import 'my_list_view.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                try {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  UserCredential userCredential =
                  await auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Get the newly created user's ID
                  String userId = userCredential.user!.uid;

                  // Use the Firestore collection reference to add the user's data to the "users" collection
                  await db.collection('users').doc(userId).set({
                    'email': email
                    // 'fullName': fullName, // Add user's full name
                  });

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );

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
                        content:
                        Text('An account with this email already exists')));
                  } else {
                    // Handle other errors
                  }
                } catch (e) {
                  // Handle other errors
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to RegistrationScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
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
