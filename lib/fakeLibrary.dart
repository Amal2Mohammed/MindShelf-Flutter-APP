// lib/fake_library.dart
import 'writer_models.dart';

class FakeLibrary {
  // authorId -> list of stories
  final Map<String, List<StoryItem>> _byAuthor = <String, List<StoryItem>>{};

  List<StoryItem> listByAuthor(String authorId) {
    return List.unmodifiable(_byAuthor[authorId] ?? const <StoryItem>[]);
  }

  StoryItem addOrUpdate(StoryItem s) {
    final list = _byAuthor.putIfAbsent(s.authorId, () => <StoryItem>[]);
    final i = list.indexWhere((e) => e.id == s.id);
    if (i == -1) {
      list.insert(0, s);
    } else {
      list[i] = s;
    }
    return s;
  }

  void delete(String authorId, String storyId) {
    final list = _byAuthor[authorId];
    list?.removeWhere((e) => e.id == storyId);
  }
}

// Singleton instance you can import everywhere.
final FakeLibrary fakeLibrary = FakeLibrary();
