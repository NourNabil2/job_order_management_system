import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String name;
  final String email;
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    Key? key,
    required this.name,
    required this.email,
    required this.isDarkTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الاسم', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.name),

            const SizedBox(height: 16),

            const Text('البريد الإلكتروني', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.email),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الوضع الداكن'),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
