import 'package:flutter/material.dart';
import 'fakeAuth.dart';
import 'fakeLibrary.dart';
import 'writer_models.dart';
import 'writer_edit_story_page.dart';

class WriterDashboardPage extends StatefulWidget {
  const WriterDashboardPage({super.key});

  @override
  State<WriterDashboardPage> createState() => _WriterDashboardPageState();
}

class _WriterDashboardPageState extends State<WriterDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final user = fakeAuth.currentUser!;
    final stories = fakeLibrary.listByAuthor(user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Library • ${user.penName ?? user.name}'),
        actions: [
          IconButton(
            onPressed: () async { await fakeAuth.logout(); if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false); },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (_) => WriterEditStoryPage(
              initial: StoryItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                authorId: user.id,
                title: '',
                genre: 'Adventure',
                level: 'A',
                minutes: 10,
                price: 0.0,
                description: '',
                content: '',
              ),
              isNew: true,
            ),
          ));
          if (mounted) setState(() {});
        },
        label: const Text('Add Story'),
        icon: const Icon(Icons.add),
      ),
      body: stories.isEmpty
          ? const Center(child: Text('No stories yet. Tap “Add Story”.'))
          : ListView.separated(
              itemCount: stories.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = stories[i];
                return ListTile(
                  title: Text(s.title.isEmpty ? '(Untitled)' : s.title),
                  subtitle: Text('${s.genre} • Level ${s.level} • ${s.minutes} min • \$${s.price.toStringAsFixed(2)}'),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => WriterEditStoryPage(initial: s, isNew: false),
                    ));
                    if (mounted) setState(() {});
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () { setState(() => fakeLibrary.delete(user.id, s.id)); },
                  ),
                );
              },
            ),
    );
  }
}
