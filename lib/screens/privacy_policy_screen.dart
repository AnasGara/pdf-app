import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'PDF Reader Pro is committed to protecting your privacy. This Privacy Policy explains how we handle your information.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Data Collection',
              'We do not collect any personal data. All your files remain on your device and are processed locally.',
            ),
            _buildSection(
              context,
              'Permissions',
              'We only request permissions necessary for the app to function, such as storage access to read your PDF files.',
            ),
            _buildSection(
              context,
              'Offline Functionality',
              'The app works completely offline and does not transmit any data to external servers.',
            ),
            _buildSection(
              context,
              'Changes to This Policy',
              'We may update our Privacy Policy from time to time. Any changes will be posted on this page.',
            ),
            const SizedBox(height: 32),
            const Text('Last Updated: May 2024'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
