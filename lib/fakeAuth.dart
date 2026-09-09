import 'package:flutter/foundation.dart';

enum AppRole { reader, writer }

class FakeUser {
  final String id;
  final String email;
  final String name;
  final AppRole role;
  final String? penName; // for writers
  final String? bio;
  FakeUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.penName,
    this.bio,
  });

  FakeUser copyWith({
    String? name,
    AppRole? role,
    String? penName,
    String? bio,
  }) => FakeUser(
    id: id,
    email: email,
    name: name ?? this.name,
    role: role ?? this.role,
    penName: penName ?? this.penName,
    bio: bio ?? this.bio,
  );
}

class FakeAuth extends ChangeNotifier {
  // pretend database (email -> password & profile map)
  final Map<String, (String password, Map<String, dynamic> profile)> _db = {};
  FakeUser? _current;
  FakeUser? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  Future<FakeUser> register({
    required String email,
    required String password,
    required String name,
    required AppRole role,
    String? penName,
    String? bio,
  }) async {
    if (_db.containsKey(email)) throw Exception('Email already registered.');
    _db[email] = (password, {
      'name': name,
      'role': role.name,
      'penName': penName,
      'bio': bio,
    });
    _current = FakeUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      role: role,
      penName: penName,
      bio: bio,
    );
    notifyListeners();
    return _current!;
  }

  Future<FakeUser> login({required String email, required String password}) async {
    final rec = _db[email];
    if (rec == null || rec.$1 != password) throw Exception('Invalid email or password.');
    final p = rec.$2;
    _current = FakeUser(
      id: email.hashCode.toString(),
      email: email,
      name: (p['name'] ?? 'User') as String,
      role: AppRole.values.firstWhere((r) => r.name == (p['role'] ?? 'reader')),
      penName: p['penName'] as String?,
      bio: p['bio'] as String?,
    );
    notifyListeners();
    return _current!;
  }

  Future<void> loginAsGuest({AppRole role = AppRole.reader}) async {
    _current = FakeUser(
      id: 'guest',
      email: 'guest@local',
      name: 'Guest',
      role: role,
    );
    notifyListeners();
  }

  Future<void> updateCurrent(FakeUser user) async {
    _current = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _current = null;
    notifyListeners();
  }
}

// one shared instance
final fakeAuth = FakeAuth();
