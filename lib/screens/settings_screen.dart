import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_notifier.dart';
import '../parts/section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final currentMode   = themeNotifier.themeMode;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? colorScheme.surface
          : colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [

          // Appearance
          const SectionHeader(title: 'Appearance'),
          _ThemeOption(
            icon: Icons.brightness_auto_outlined,
            label: 'System Default',
            selected: currentMode == ThemeMode.system,
            onTap: () => themeNotifier.setTheme(ThemeMode.system),
          ),
          _ThemeOption(
            icon: Icons.light_mode_outlined,
            label: 'Light',
            selected: currentMode == ThemeMode.light,
            onTap: () => themeNotifier.setTheme(ThemeMode.light),
          ),
          _ThemeOption(
            icon: Icons.dark_mode_outlined,
            label: 'Dark',
            selected: currentMode == ThemeMode.dark,
            onTap: () => themeNotifier.setTheme(ThemeMode.dark),
          ),
          const Divider(),

          // Preferences
          const SectionHeader(title: 'Preferences'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: _notifications,
            onChanged: (val) => setState(() => _notifications = val),
          ),
          const Divider(),

          // About
          const SectionHeader(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
          const ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Terms of Service'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.chevron_right),
          ),

          const Divider(),

          // const SectionHeader(title: 'Session'),
          ListTile(
            title: const Text('Safe Port', style: TextStyle(color: Colors.grey)
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme option tile ────────────────────────────────────────────────────────

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String   label;
  final bool     selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: selected
          ? Icon(Icons.check_circle, color: color)
          : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      onTap: onTap,
    );
  }
}

