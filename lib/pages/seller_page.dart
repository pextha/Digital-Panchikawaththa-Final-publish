import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});

  // Launch phone dialer
  void _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Launch SMS app
  void _launchSMS(String phoneNumber) async {
    final Uri url = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildCreativeProfileCard(context),
            // You can add your menu and recent purchases widgets here
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Seller Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCreativeProfileCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/profile.jpeg"),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'John Snow',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'johnsnow@gmail.com',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _infoRow(
                icon: Icons.location_on,
                label: 'Province',
                value: 'Central Province'),
            const SizedBox(height: 8),
            _infoRow(icon: Icons.map, label: 'District', value: 'Kandy'),
            const SizedBox(height: 8),
            _infoRow(
                icon: Icons.home,
                label: 'Address',
                value: '123 Main Street, Uggal-Oya'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  context,
                  icon: Icons.call_outlined,
                  label: 'Call',
                  color: Colors.white,
                  onTap: () {
                    _launchCaller(
                        '+94712345678'); // Replace with actual phone number
                  },
                ),
                _actionButton(
                  context,
                  icon: Icons.message_outlined,
                  label: 'Message',
                  color: Colors.white,
                  onTap: () {
                    _launchSMS(
                        '+94712345678'); // Replace with actual phone number
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(30),
          color: color.withOpacity(0.15),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
