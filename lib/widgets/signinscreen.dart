import '../util/appuser.dart';

import '../util/appauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppAuth().onAuthChange.listen((AppUser result) {
      if (result != null) {
        try {
          Navigator.of(context).pushReplacementNamed('/home');
        } on FlutterError catch(e) {
          print("Caught Exception in _handleAuthChange: $e");
        }
        
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/signin_bkg.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken),
        )),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 16.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            color: Color.fromARGB(255, 255, 255, 255),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GoogleSignInButton(
                      onPressed: () {
                        AppAuth().signInWithGoogle();
                      },
                      borderRadius: 10.0,
                      darkMode: true,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FacebookSignInButton(
                      onPressed: () {
                        AppAuth().signInWithFacebook();
                      },
                      text: "Sign in with Facebook",
                      borderRadius: 10.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TwitterSignInButton(
                      onPressed: () {},
                      borderRadius: 10.0,
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
                          )),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
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
                              obscureText: true,
                              decoration: const InputDecoration(
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
                            RaisedButton(
                              onPressed: () {},
                              color: Colors.green,
                              textTheme: ButtonTextTheme.primary,
                              child: Text("Submit"),
                              padding: EdgeInsets.symmetric(horizontal: 80.0),
                            ),
                            Text("Forgot your password?"),
                            SizedBox(height: 12.0),
                            Divider(
                              color: Colors.grey,
                              indent: 16.0,
                              endIndent: 16.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "First Time? Sign in with social media or Register with Email/Password",
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
