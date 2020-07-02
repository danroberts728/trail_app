import 'package:alabama_beer_trail/screens/screen_forgot_password.dart';
import 'package:alabama_beer_trail/util/trail_app_settings.dart';

import '../blocs/appauth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SigninScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _SigninScreen();
}

enum SubmitButtonState { Waiting, Working }

class _SigninScreen extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _formError;
  SubmitButtonState _submitButtonState = SubmitButtonState.Waiting;
  GlobalKey _scaffoldKey = GlobalKey();

  String get formError {
    String tmp = _formError;
    _formError = null;
    return tmp;
  }

  @override
  void initState() {
    super.initState();  
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(TrailAppSettings.signInAppBarTitle),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(TrailAppSettings.signInBackgroundAsset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken),
        )),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Card(
            elevation: 16.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            color: Colors.white,
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
                              controller: _passwordController,
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
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _submitButtonState =
                                        SubmitButtonState.Working;
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
                              child: _submitButtonState ==
                                      SubmitButtonState.Waiting
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
                                        color: TrailAppSettings.signInForgotPwdColor),
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
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Password reset sent to $emailAddress"),
                                      ));
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
                                  style: TextStyle(color: TrailAppSettings.errorColor)),
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
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
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
        ),
      ),
    );
  }
}
