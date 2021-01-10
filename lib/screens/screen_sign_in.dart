// Copyright (c) 2020, Fermented Software.
import 'dart:io';
import 'dart:async';

import 'package:alabama_beer_trail/screens/screen_forgot_password.dart';
import 'package:alabama_beer_trail/screens/screen_register.dart';
import 'package:alabama_beer_trail/util/appauth.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

/// The App Sign in Screen
class ScreenSignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScreenSignIn();
}

enum SubmitButtonState { Waiting, Working }

/// State for ScreenSignIn
class _ScreenSignIn extends State<ScreenSignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SubmitButtonState _submitButtonState = SubmitButtonState.Waiting;
  String _formError;
  StreamSubscription _authSubscription;

  String get formError {
    String tmp = _formError;
    _formError = null;
    return tmp;
  }

  @override
  void initState() {
    _authSubscription = AppAuth().onAuthChange.listen((user) {
      if (Navigator.canPop(context)) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Container(
        color: Colors.black12,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FittedBox(
                  child: GoogleSignInButton(
                    onPressed: () {
                      AppAuth().signInWithGoogle();
                    },
                    borderRadius: 10.0,
                    darkMode: true,
                  ),
                ),
                SizedBox(
                  height: Platform.isIOS ? 10.0 : 0.0,
                ),
                Platform.isIOS
                    ? FittedBox(
                        child: AppleSignInButton(
                        borderRadius: 10.0,
                        onPressed: () {
                          AppAuth().signInWithApple();
                        },
                      ))
                    : SizedBox(height: 0),
                SizedBox(
                  height: 10.0,
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
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: "user@mydomain.com",
                            labelText: "Email Address",
                            labelStyle: TextStyle(
                              color: TrailAppSettings.subHeadingColor,
                            ),
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
                            labelStyle: TextStyle(
                              color: TrailAppSettings.subHeadingColor,
                            ),
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _submitButtonState = SubmitButtonState.Working;
                              });
                              AppAuth()
                                  .signInWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text)
                                  .then((AppAuthReturn result) {
                                if (result.success == false) {
                                  setState(() {
                                    _formError = result.errorMessage;
                                    _submitButtonState =
                                        SubmitButtonState.Waiting;
                                  });
                                }
                              });
                            }
                          },
                          color: TrailAppSettings.signInSignInButtonColor,
                          textTheme: ButtonTextTheme.primary,
                          padding: EdgeInsets.symmetric(horizontal: 80.0),
                          child: _submitButtonState == SubmitButtonState.Waiting
                              ? Text(TrailAppSettings.signInButtonText)
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                        ),
                        SizedBox(height: 12.0),
                        Builder(
                          builder: (context) {
                            return InkWell(
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                    color:
                                        TrailAppSettings.signInForgotPwdColor),
                              ),
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            settings: RouteSettings(
                                              name: 'About',
                                            ),
                                            builder: (context) =>
                                                PasswordResetScreen()))
                                    .then((emailAddress) {
                                  if (emailAddress != null) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "Password reset sent to $emailAddress"),
                                    ));
                                  }
                                });
                              },
                            );
                          },
                        ),
                        SizedBox(height: 6.0),
                        Container(
                          alignment: Alignment.center,
                          child: Text(_formError == null ? '' : formError,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TrailAppSettings.errorColor)),
                        ),
                        SizedBox(height: 6.0),
                        Divider(
                          color: Colors.grey,
                          indent: 16.0,
                          endIndent: 16.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "First Time?",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          Platform.isIOS
                              ? "Sign in with Google or Apple above, or"
                              : "Sign in with Google above, or",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: RouteSettings(
                                      name: 'Register with Email/Password'),
                                  builder: (context) => RegisterScreen(),
                                ));
                          },
                          child: Text(
                            "Register with Email/Password",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          textColor: TrailAppSettings.actionLinksColor,
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
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
