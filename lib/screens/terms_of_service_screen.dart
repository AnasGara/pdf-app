import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              'By using PDF Reader Pro, you agree to the following terms and conditions.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Usage',
              'You may use the app for personal, non-commercial purposes. You are responsible for the content you open with the app.',
            ),
            _buildSection(
              context,
              'Disclaimer',
              'The app is provided "as is" without any warranties. We are not responsible for any data loss or damage to your device.',
            ),
            _buildSection(
              context,
              'Intellectual Property',
              'The app and its original content, features, and functionality are owned by Anas Gara and are protected by international copyright laws.',
            ),
            _buildSection(
              context,
              'Termination',
              'We reserve the right to terminate or suspend access to our app immediately, without prior notice or liability, for any reason whatsoever.',
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
