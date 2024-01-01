import 'package:client/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:client/classes/auth.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  void dialog() {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent!'),
          );
        },
      );
    } catch (e) {
      showErrorSnackbar(context, e.toString());
    }
  }

  final auth = Auth();
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Center(
            child: Text(
              'Reset your password !',
              style: TextStyle(
                color: Colors.black,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter your email', textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  controller: _emailController,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await context
                      .read<Auth>()
                      .resetPassword(_emailController.text.trim());
                  dialog();
                },
                child: const Text(
                  'Reset password',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      showErrorSnackbar(context, e.toString());
      return const Scaffold(
        body: Center(
          child: Text('An unexpected error occurred'),
        ),
      );
    }
  }
}
