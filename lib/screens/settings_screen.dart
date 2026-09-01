import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, 
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0, 
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 30, left: 0, right: 0),
        children: [
          // ================= ACCOUNT SECTION =================
          _buildSectionHeader('Account'),
          
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Change your personal info',
            onTap: () {
              // Navigate to EditProfileScreen
            },
          ),
          
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ================= PREFERENCES SECTION =================
          _buildSectionHeader('Preferences'),

          // Toggle for Dark Mode
          SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Enable dark theme',
            trailing: Switch(
              value: _isDarkMode,
              activeThumbColor: Colors.blue,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),

          // Toggle for Notifications
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Enable push notifications',
            trailing: Switch(
              value: _isNotificationsEnabled,
              activeThumbColor: Colors.blue,
              onChanged: (bool value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                _isNotificationsEnabled = !_isNotificationsEnabled;
              });
            },
          ),

          const SizedBox(height: 20),

          // ================= ABOUT SECTION =================
          _buildSectionHeader('About'),

          SettingsTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: 'v1.0.0',
            onTap: () {},
            trailing: null, // ✅ Hides the arrow for this tile
          ),

          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {},
          ),

          SettingsTile(
            icon: Icons.support_agent,
            title: 'Help & Support',
            subtitle: 'Contact customer support',
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // ================= LOGOUT BUTTON =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}