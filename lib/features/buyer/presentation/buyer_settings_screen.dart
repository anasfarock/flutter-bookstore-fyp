
import 'package:flutter/material.dart';

class BuyerSettingsScreen extends StatefulWidget {
  const BuyerSettingsScreen({super.key});

  @override
  State<BuyerSettingsScreen> createState() => _BuyerSettingsScreenState();
}

class _BuyerSettingsScreenState extends State<BuyerSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive order updates and offers'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
             subtitle: const Text('Enable dark theme'),
            value: _darkMode,
            onChanged: (val) {
              setState(() => _darkMode = val);
              // In real app, this would toggle ThemeProvider
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme Updated (Mock)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
           ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
           ListTile(
            title: const Text('About App'),
            subtitle: const Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
