import 'package:flutter/material.dart';
import 'writer_register_page.dart';

class ChooseRolePage extends StatelessWidget {
  const ChooseRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Role')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RoleCard(
              color: Colors.teal.shade50,
              borderColor: Colors.teal.shade200,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/gifs/reading.gif',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: 'Reader',
              subtitle: 'Read time-fitted stories by genre and level',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reader registration coming soon. Choose Writer for now.')),
                );
              },
            ),
            const SizedBox(height: 14),
            RoleCard(
              color: Colors.amber.shade50,
              borderColor: Colors.amber.shade200,
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit, size: 28, color: Colors.black87),
              ),
              title: 'Writer',
              subtitle: 'Publish your stories and set prices',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WriterRegisterPage()),
              ),
            ),
            const Spacer(),
            Text(
              'You can change your role later in settings.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable pretty card with ripple and rounded corners
class RoleCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;
  final Color borderColor;

  const RoleCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: borderColor),
            ],
          ),
        ),
      ),
    );
  }
}
