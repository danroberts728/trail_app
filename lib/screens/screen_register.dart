import 'package:alabama_beer_trail/util/trail_app_settings.dart';
import 'package:flutter/material.dart';
import '../util//appauth.dart';

class RegisterScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text('CREATE ACCOUNT',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: TrailAppSettings.first,
                                )),
                            Divider(
                              color: TrailAppSettings.fourth,
                              indent: 50.0,
                              endIndent: 50.0,
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.email),
                                hintText: "user@mydomain.com",
                                labelText: "Email Address",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter an email";
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email";
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
                                if (value.length < 8) {
                                  return "Password must be at least 8 characters long";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _password2Controller,
                              obscureText: true,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock),
                                labelText: "Confirm Password",
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  AppAuth()
                                      .register(_emailController.text,
                                          _passwordController.text)
                                      .then((user) {
                                    if (user == null) {
                                      setState(() {
                                        _success = false;
                                      });
                                    } else {
                                      setState(() {
                                        _success = true;
                                      });
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                              color: Colors.green,
                              textTheme: ButtonTextTheme.primary,
                              child: Text("Register"),
                              padding: EdgeInsets.symmetric(horizontal: 80.0),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text("Have an account?"),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              textColor: TrailAppSettings.second,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                _success == null
                                    ? ''
                                    : AppAuth().registrationUserError == null
                                        ? "Registration Failed"
                                        : AppAuth().registrationUserError,
                                style: TextStyle(color: Colors.red),
                              ),
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
