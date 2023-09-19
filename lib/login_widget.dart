import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tools/home_page.dart';
import 'package:firebase_tools/main.dart';
import 'package:firebase_tools/services/firebase_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forgotpassword_page.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('images/task-list-2.png'),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(
                Icons.lock_open,
                size: 32,
              ),
              label: Text(
                'Sign In',
                style: TextStyle(fontSize: 24),
              ),
              // onPressed: signIn,
              onPressed:()=> FirebaseHelper.helloWorld() ,
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              child: Text(
                'Forgot Password',
                style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    color: Colors.teal),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RichText(
              text: TextSpan(
                  text: 'No Account?  ',
                  style: TextStyle(color: Colors.grey),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Sign Up',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                            color: Colors.teal))
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
