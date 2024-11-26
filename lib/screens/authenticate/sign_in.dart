import 'package:conference_management_system/services/auth.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:conference_management_system/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: bodyBackgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              elevation: 0.0,
              title: const Text('Sign in to the system'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Register"),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    _buildEmailField(),
                    const SizedBox(height: 20.0),
                    _buildPasswordField(),
                    const SizedBox(height: 20.0),
                    _buildSignInButton(),
                    const SizedBox(height: 12.0),
                    _buildErrorText(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Email'),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter an email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
          return 'Enter a valid email';
        }
        return null; // Return null if validation passes
      },
      onChanged: (val) {
        setState(() => email = val.trim());
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: 'Password'),
      obscureText: true,
      validator: (val) {
        if (val == null || val.length < 6) {
          return 'Minimum 6 characters';
        }
        return null; // Return null if validation passes
      },
      onChanged: (val) {
        setState(() => password = val);
      },
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[200],
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() => loading = true);
          dynamic result =
              await _auth.signInWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              error = 'Could not sign in with those credentials';
              loading = false;
            });
          } else {
            // Optional: Navigate to the next screen or show success
          }
        }
      },
    );
  }

  Widget _buildErrorText() {
    return Text(
      error,
      style: const TextStyle(color: Colors.red, fontSize: 14.0),
    );
  }
}
