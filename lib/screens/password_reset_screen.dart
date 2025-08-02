import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _usernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _errorMessage;
  String? _successMessage;
  String? _tempPassword;
  bool _showNewPasswordField = false;

  void _checkUsername() {
    final appState = Provider.of<AppState>(context, listen: false);
    final username = _usernameController.text.trim();
    
    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username';
        _successMessage = null;
      });
      return;
    }

    if (appState.userExists(username)) {
      // Generate a temporary password for demonstration
      final tempPassword = 'temp${DateTime.now().millisecondsSinceEpoch % 10000}';
      setState(() {
        _errorMessage = null;
        _tempPassword = tempPassword;
        _showNewPasswordField = true;
        _successMessage = 'Username found! Your temporary password is: $tempPassword\nYou can also set a new password below.';
      });
    } else {
      setState(() {
        _errorMessage = 'Username not found';
        _successMessage = null;
        _tempPassword = null;
        _showNewPasswordField = false;
      });
    }
  }

  void _resetPassword() {
    final appState = Provider.of<AppState>(context, listen: false);
    final username = _usernameController.text.trim();
    String newPassword;

    if (_newPasswordController.text.trim().isNotEmpty) {
      newPassword = _newPasswordController.text.trim();
    } else if (_tempPassword != null) {
      newPassword = _tempPassword!;
    } else {
      setState(() {
        _errorMessage = 'Please enter a new password or use the temporary password';
      });
      return;
    }

    final success = appState.resetPassword(username, newPassword);
    
    if (success) {
      // Show success dialog and navigate back to login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset Successful'),
          content: const Text('Your password has been updated. You can now log in with your new password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to reset password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              appState.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your username to reset your password',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkUsername,
              child: const Text('Check Username'),
            ),
            if (_showNewPasswordField) ...[
              const SizedBox(height: 24),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Leave empty to use temporary password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Reset Password'),
              ),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (_successMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}