import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(child: Icon(Icons.info_outline, size: 80, color: colorScheme.primary)),
            const SizedBox(height: 20),
            Text('تطبيق متابعة مشكلات البنية التحتية', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'يساعد التطبيق الفنيين في استقبال وتنفيذ البلاغات من الجهات الحكومية بشكل سلس وسريع.',
              style: textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 20),
            Text('الدعم الفني:', style: textTheme.titleMedium),
            TextButton(
              onPressed: () => launchUrl(Uri.parse('mailto:support@example.com')),
              child: const Text('support@example.com'),
            )
          ],
        ),
      ),
    );
  }
}
