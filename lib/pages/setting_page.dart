import 'package:flutter/material.dart';
import 'package:panchikawaththa/pages/ManageAddressPage.dart';
import 'package:panchikawaththa/pages/TwoFactorPage.dart';
import 'package:panchikawaththa/pages/change_password_page.dart';
import 'package:panchikawaththa/pages/contactUs.dart';
import 'package:panchikawaththa/pages/edit_profile_page.dart';
import 'package:panchikawaththa/pages/help_center_page.dart';
import 'package:panchikawaththa/pages/languageSettings.dart';
import 'package:panchikawaththa/pages/leaveFeadback.dart';
import 'package:panchikawaththa/pages/logout.dart';
import 'package:panchikawaththa/pages/notificationSetting.dart';
import 'package:panchikawaththa/pages/paymentMethodSetting.dart';
import 'package:panchikawaththa/pages/privacy.dart';
import 'package:panchikawaththa/pages/reportProblem.dart';
import 'package:panchikawaththa/pages/tearms_conditions.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Account & Security'),
          SettingsTile(
              title: 'Change Password',
              icon: Icons.lock,
              page: const ChangePasswordPage()),
          SettingsTile(
              title: 'Two-Factor Authentication',
              icon: Icons.shield_outlined,
              page: const TwoFactorPage()),
          SettingsTile(
              title: 'Logout', icon: Icons.logout, page: const LogoutPage()),
          const SectionHeader(title: 'Profile'),
          SettingsTile(
              title: 'Edit Profile',
              icon: Icons.person,
              page: const EditProfilePage()),
          SettingsTile(
              title: 'Manage Address',
              icon: Icons.location_on,
              page: const ManageAddressPage()),
          SettingsTile(
              title: 'Payment Methods',
              icon: Icons.payment,
              page: const PaymentMethodsPage()),
          const SectionHeader(title: 'App Preferences'),
          SettingsTile(
              title: 'Language',
              icon: Icons.language,
              page: const LanguageSettingsPage()),
          SettingsTile(
              title: 'Theme Mode',
              icon: Icons.brightness_6,
              page: const ThemeModePage()),
          SettingsTile(
              title: 'Notifications',
              icon: Icons.notifications,
              page: const NotificationsettingPage()),
          const SectionHeader(title: 'Support & Feedback'),
          SettingsTile(
              title: 'Help Center',
              icon: Icons.help_outline,
              page: const HelpCenterPage()),
          SettingsTile(
              title: 'Contact Us',
              icon: Icons.mail_outline,
              page: const ContactUsPage()),
          SettingsTile(
              title: 'Report a Problem',
              icon: Icons.bug_report,
              page: const ReportProblemPage()),
          SettingsTile(
              title: 'Leave Feedback',
              icon: Icons.feedback,
              page: const LeaveFeedbackPage()),
          const SectionHeader(title: 'Legal & About'),
          SettingsTile(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip,
              page: const PrivacyPolicyPage()),
          SettingsTile(
              title: 'Terms & Conditions',
              icon: Icons.description,
              page: const TermsConditionsPage()),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;
  const SettingsTile(
      {required this.title, required this.icon, required this.page});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF02B91A)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

class ThemeModePage extends StatelessWidget {
  const ThemeModePage({super.key});
  @override
  Widget build(BuildContext context) => _buildScreen(context, 'Theme Mode');
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  @override
  Widget build(BuildContext context) => _buildScreen(context, 'Notifications');
}

Widget _buildScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
        child: Text('This is the $title screen',
            style: const TextStyle(fontSize: 16))),
  );
}
