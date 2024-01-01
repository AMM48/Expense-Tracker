import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message,
    {IconData? icon, Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(
              icon ??
                  Icons
                      .error_outline, // Use provided icon or default to error icon
              color: Colors.white,
            ),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

void showErrorSnackbar(BuildContext context, String error) {
  showSnackbar(context, 'Error: $error',
      icon: Icons.error_outline_sharp, backgroundColor: Colors.red);
}

void showSuccessSnackbar(BuildContext context, String message) {
  showSnackbar(context, message,
      icon: Icons.check_circle_outline_sharp,
      backgroundColor: Colors.lightGreen);
}
