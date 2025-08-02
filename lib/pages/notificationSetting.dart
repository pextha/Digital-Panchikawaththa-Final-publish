import 'package:flutter/material.dart';

class NotificationsettingPage extends StatefulWidget {
  const NotificationsettingPage({super.key});

  @override
  State<NotificationsettingPage> createState() =>
      _NotificationsettingPageState();
}

class _NotificationsettingPageState extends State<NotificationsettingPage> {
  bool pushNotifications = true;
  bool emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Push Notifications"),
            value: pushNotifications,
            activeColor: Color(0xFF02B91A), // Set active color
            onChanged: (val) {
              setState(() {
                pushNotifications = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Email Alerts"),
            value: emailAlerts,
            activeColor: Color(0xFF02B91A), // Set active color
            onChanged: (val) {
              setState(() {
                emailAlerts = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
