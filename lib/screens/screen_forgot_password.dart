import 'package:trail_auth/trail_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PasswordResetScreen();
}

class _PasswordResetScreen extends State<PasswordResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final String _emailRegex =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
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
                    Text(
                      "Forgot your password? Send us your email below and we'll send you instructions on how to reset.",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Form(
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
                                } else if (!RegExp(_emailRegex)
                                    .hasMatch(value)) {
                                  return "Please enter a valid email address";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  TrailAuth()
                                      .resetPassword(_emailController.text);
                                  Navigator.pop(context, _emailController.text);
                                }
                              },
                              color: Colors.green,
                              textTheme: ButtonTextTheme.primary,
                              padding: EdgeInsets.symmetric(horizontal: 80.0),
                              child: Text("Reset Password"),
                            ),
                          ],
                        ))
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
