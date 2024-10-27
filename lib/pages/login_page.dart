import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salypai/services/firebase/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _isLoading = false;
  bool _forLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_forLogin ? widget.title : "S'inscrire"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!_forLogin)
                    TextFormField(
                      controller: _passwordConfirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password confirmation',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Confirmation is required';
                        } else if (value != _passwordController.text) {
                          return 'The two password doesn\'t match';
                        } else {
                          return null;
                        }
                      },
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  // Login
                                  try {
                                    if (_forLogin) {
                                      await Auth().loginWithEmailAndPassword(
                                          _emailController.text,
                                          _passwordController.text);
                                    } else {
                                      await Auth()
                                          .createUserWithEmailAndPassword(
                                              _emailController.text,
                                              _passwordController.text);
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    // Message Error
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("${e.message}"),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      showCloseIcon: true,
                                    ));
                                  }
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(_forLogin ? 'Login' : "S'inscrire")),
                  ),
                  SizedBox(
                    child: TextButton(
                        onPressed: () {
                          _emailController.text = "";
                          _passwordController.text = "";
                          _passwordConfirmController.text = "";
                          setState(() {
                            _forLogin = !_forLogin;
                          });
                        },
                        child: Text(_forLogin
                            ? "J'ai ne pas un compte, S'inscrire"
                            : "J'ai déjà un compte se connecter")),
                  )
                ],
              )),
        ));
  }
}
