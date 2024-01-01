import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:client/register.dart';
import 'package:client/classes/auth.dart';
import 'package:client/reset_password.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  final VoidCallback onUserLoggedIn;

  const LoginPage({
    Key? key,
    required this.onUserLoggedIn,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } catch (e) {
      showErrorSnackbar(context, e.toString());
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await context.read<Auth>().loginUser(email: username, password: password);
      widget.onUserLoggedIn();
    } catch (e) {
      setState(() {
        _errorMessage = Auth().handleFirebaseAuthError(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // make the app bar transparent
        elevation: 0,
        title: const Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.black, // set the color of the text
              fontSize: 20.0,
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          try {
                            _handleLogin();
                          } catch (e) {
                            showErrorSnackbar(context, e.toString());
                          }
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterPage.routeName);
                },
                child: const Text(
                  'Don\'t have an account? Sign up now',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16), // Add some spacing
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    "Don't remember your password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
