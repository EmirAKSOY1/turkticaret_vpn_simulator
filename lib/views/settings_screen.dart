import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: Color(0xFF1A5CFF), fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1A5CFF)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF1A5CFF),
                child: const Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('User Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF333333))),
                  SizedBox(height: 4),
                  Text('user@email.com', style: TextStyle(color: Color(0xFF666666))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dark Mode', style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
              Switch(
                value: isDarkMode,
                activeColor: const Color(0xFF1A5CFF),
                onChanged: (val) {
                  setState(() => isDarkMode = val);
                },
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Language', style: TextStyle(fontSize: 16, color: Color(0xFF333333))),
              DropdownButton<String>(
                value: selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Turkish', child: Text('Turkish')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedLanguage = val);
                },
              ),
            ],
          ),
          const Divider(height: 32),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline, color: Color(0xFF1A5CFF)),
            title: const Text('About', style: TextStyle(color: Color(0xFF333333))),
            subtitle: const Text('VPN Simulator v1.0.0'),
          ),
        ],
      ),
    );
  }
} 