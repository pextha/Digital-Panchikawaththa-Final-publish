import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Simulate password check
      if (currentController.text != "user_current_password") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Current password is incorrect")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );

      // Clear fields
      currentController.clear();
      newController.clear();
      confirmController.clear();
    }
  }

  InputDecoration _inputDecoration(
      String label, bool obscure, VoidCallback toggle) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: Colors.green),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ← Go back on tap
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentController,
                obscureText: _obscureCurrent,
                decoration:
                    _inputDecoration("Current Password", _obscureCurrent, () {
                  setState(() => _obscureCurrent = !_obscureCurrent);
                }),
                validator: (value) => value == null || value.isEmpty
                    ? "Enter current password"
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: newController,
                obscureText: _obscureNew,
                decoration: _inputDecoration("New Password", _obscureNew, () {
                  setState(() => _obscureNew = !_obscureNew);
                }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter new password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmController,
                obscureText: _obscureConfirm,
                decoration: _inputDecoration(
                    "Confirm New Password", _obscureConfirm, () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                }),
                validator: (value) => value != newController.text
                    ? "Passwords do not match"
                    : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 16),
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
