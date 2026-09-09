import 'package:flutter/material.dart';
import 'fakeAuth.dart';
import 'writer_dashboard_page.dart';

class WriterRegisterPage extends StatefulWidget {
  const WriterRegisterPage({super.key});

  @override
  State<WriterRegisterPage> createState() => _WriterRegisterPageState();
}

class _WriterRegisterPageState extends State<WriterRegisterPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _pen = TextEditingController();
  final _bio = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _pass.dispose(); _pen.dispose(); _bio.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await fakeAuth.register(
        email: _email.text.trim(),
        password: _pass.text,
        name: _name.text.trim(),
        role: AppRole.writer,
        penName: _pen.text.trim(),
        bio: _bio.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WriterDashboardPage()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Writer Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name')),
              const SizedBox(height: 12),
              TextFormField(controller: _pen, decoration: const InputDecoration(labelText: 'Pen name')),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pass,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => (v == null || v.length < 4) ? 'Min 4 characters' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bio,
                decoration: const InputDecoration(labelText: 'Short bio'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading ? const CircularProgressIndicator() : const Text('Create writer account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
