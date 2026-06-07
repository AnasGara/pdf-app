import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/pdf_provider.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SectionTitle(title: 'Appearance'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Theme'),
                subtitle: Text(_themeModeToString(themeProvider.themeMode)),
                onTap: () => _showThemeDialog(context, themeProvider),
              );
            },
          ),
          const Divider(),
          const _SectionTitle(title: 'Data Management'),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear History'),
            onTap: () => _showClearDialog(context, 'history'),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_remove),
            title: const Text('Clear Bookmarks'),
            onTap: () => _showClearDialog(context, 'bookmarks'),
          ),
          const Divider(),
          const _SectionTitle(title: 'Legal'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
              );
            },
          ),
          const Divider(),
          const _SectionTitle(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              title: 'System',
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Light',
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
            _ThemeOption(
              title: 'Dark',
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (mode) {
                themeProvider.setThemeMode(mode!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear $type'),
        content: Text('Are you sure you want to clear all $type? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final provider = Provider.of<PdfProvider>(context, listen: false);
              if (type == 'history') {
                provider.clearHistory();
              } else {
                provider.clearBookmarks();
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cleared all $type')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final ThemeMode value;
  final ThemeMode groupValue;
  final ValueChanged<ThemeMode?> onChanged;

  const _ThemeOption({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
