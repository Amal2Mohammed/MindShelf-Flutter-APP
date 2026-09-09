import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

import 'fakeLibrary.dart';
import 'writer_models.dart';

class WriterEditStoryPage extends StatefulWidget {
  final StoryItem initial;
  final bool isNew;
  const WriterEditStoryPage({super.key, required this.initial, required this.isNew});

  @override
  State<WriterEditStoryPage> createState() => _WriterEditStoryPageState();
}

class _WriterEditStoryPageState extends State<WriterEditStoryPage> {
  final _form = GlobalKey<FormState>();
  late StoryItem s;

  @override
  void initState() {
    super.initState();
    s = StoryItem(
      id: widget.initial.id,
      authorId: widget.initial.authorId,
      title: widget.initial.title,
      genre: widget.initial.genre,
      level: widget.initial.level,
      minutes: widget.initial.minutes,
      price: widget.initial.price,
      description: widget.initial.description,
      content: widget.initial.content,
      coverPath: widget.initial.coverPath,
      pdfPath: widget.initial.pdfPath,
    );
  }

  Future<void> _pickCover() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (res != null && res.files.single.path != null) {
      setState(() => s.coverPath = res.files.single.path!);
    }
  }

  Future<void> _pickPdf() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (res != null && res.files.single.path != null) {
      setState(() => s.pdfPath = res.files.single.path!);
    }
  }

  void _openPdf() {
    final path = s.pdfPath;
    if (path != null) {
      OpenFilex.open(path);
    }
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    if (s.pdfPath == null || s.pdfPath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a PDF file for this story.')),
      );
      return;
    }
    fakeLibrary.addOrUpdate(s);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? 'Add Story' : 'Edit Story'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== Cover picker =====
              Text('Cover', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 90,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black12,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: s.coverPath == null
                        ? const Center(child: Icon(Icons.image, size: 32, color: Colors.black45))
                        : Image.file(File(s.coverPath!), fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonalIcon(
                    onPressed: _pickCover,
                    icon: const Icon(Icons.photo),
                    label: Text(s.coverPath == null ? 'Select cover image' : 'Change cover'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== PDF picker =====
              Text('Story PDF', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.indigo),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.pdfPath == null ? 'No file selected' : p.basename(s.pdfPath!),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _pickPdf,
                      icon: const Icon(Icons.upload_file),
                      label: Text(s.pdfPath == null ? 'Select PDF' : 'Change'),
                    ),
                    if (s.pdfPath != null) ...[
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _openPdf,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open'),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== Meta fields (same as you had) =====
              TextFormField(
                initialValue: s.title,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (v) => s.title = v,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: s.genre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items: const [
                  DropdownMenuItem(value: 'Adventure', child: Text('Adventure')),
                  DropdownMenuItem(value: 'Mystery', child: Text('Mystery')),
                  DropdownMenuItem(value: 'Science', child: Text('Science')),
                  DropdownMenuItem(value: 'Fantasy', child: Text('Fantasy')),
                  DropdownMenuItem(value: 'Animals', child: Text('Animals')),
                  DropdownMenuItem(value: 'History', child: Text('History')),
                ],
                onChanged: (v) => s.genre = v ?? s.genre,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: s.level,
                decoration: const InputDecoration(labelText: 'Level'),
                items: const [
                  DropdownMenuItem(value: 'A', child: Text('A (Beginner)')),
                  DropdownMenuItem(value: 'B', child: Text('B (Intermediate)')),
                  DropdownMenuItem(value: 'C', child: Text('C (Advanced)')),
                ],
                onChanged: (v) => s.level = v ?? s.level,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: s.minutes.toString(),
                decoration: const InputDecoration(labelText: 'Target minutes'),
                keyboardType: TextInputType.number,
                onChanged: (v) => s.minutes = int.tryParse(v) ?? s.minutes,
                validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter minutes' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: s.price.toStringAsFixed(2),
                decoration: const InputDecoration(prefixText: '\$', labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => s.price = double.tryParse(v) ?? s.price,
                validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Price must be ≥ 0' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: s.description,
                decoration: const InputDecoration(labelText: 'Short description'),
                maxLines: 2,
                onChanged: (v) => s.description = v,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: s.content,
                decoration: const InputDecoration(labelText: 'Full story (for preview/testing)'),
                maxLines: 8,
                onChanged: (v) => s.content = v,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
