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
  String username = '';
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
                    // TextFormField(
                    //   decoration: textInputDecoration.copyWith(
                    //     labelText: 'Username',
                    //     prefixIcon: const Icon(Icons.person_outline),
                    //   ),
                    //   validator: (val) =>
                    //       val!.isEmpty ? 'Enter a username' : null,
                    //   onChanged: (val) {
                    //     setState(() => username = val);
                    //   },
                    // ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                            email,
                            password,
                            username,
                          );
                          if (result == null) {
                            setState(() {
                              error = 'Please supply a valid email';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
