import 'package:flutter/material.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  bool isEnabled = false;
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false;

  void _toggle2FA() {
    if (!isEnabled) {
      // Simulate sending OTP
      setState(() {
        otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("OTP sent to your registered email/phone")),
      );
    } else {
      // Disable 2FA directly
      setState(() {
        isEnabled = false;
        otpSent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Two-Factor Authentication Disabled")),
      );
    }
  }

  void _verifyOTP() {
    if (otpController.text == "123456") {
      // Simulated OTP
      setState(() {
        isEnabled = true;
        otpSent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Two-Factor Authentication Enabled")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Two-Factor Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add extra security to your account by enabling 2FA.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: isEnabled || otpSent,
              onChanged: (_) => _toggle2FA(),
              activeColor: Colors.green,
              title: Text(isEnabled ? "2FA is Enabled" : "Enable 2FA"),
            ),
            const SizedBox(height: 20),
            if (otpSent) ...[
              const Text("Enter the 6-digit code sent to your phone/email:"),
              const SizedBox(height: 10),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "OTP Code",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                cursorColor: Colors.green,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
