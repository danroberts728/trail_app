import 'package:beer_trail_admin/app_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            child: Column(
              children: [
                SignInButton(
                  buttonSize: ButtonSize.medium,
                  buttonType: ButtonType.google,
                  onPressed: () {
                    AppAuth(FirebaseAuth.instance).signInWithGoogle();
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Text(
                    "OR",
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: "user@mydomain.com",
                          labelText: "Email Address",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter an email address";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 6.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            AppAuth(FirebaseAuth.instance)
                                .signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
