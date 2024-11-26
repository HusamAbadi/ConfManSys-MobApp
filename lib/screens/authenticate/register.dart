import 'package:conference_management_system/services/auth.dart';
import 'package:conference_management_system/shared/constants.dart';
import 'package:conference_management_system/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              title: const Text('Sign up to the system'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Sign In"),
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
                    _buildRegisterButton(),
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

  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[200],
      ),
      child: const Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() => loading = true);
          dynamic result =
              await _auth.registerWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              error = 'Please supply a valid email';
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
