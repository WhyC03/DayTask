import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  User? _user;
  bool _isLoading = true;
  String? _fullName;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get fullName => _fullName;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final session = _client.auth.currentSession;
    _user = session?.user;
    if (_user != null) {
      await fetchProfile();
    }
    _isLoading = false;
    notifyListeners();

    _client.auth.onAuthStateChange.listen((data) async {
      _user = data.session?.user;
      if (_user != null) {
        await fetchProfile();
      } else {
        _fullName = null;
      }
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String fullName) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      await _client.from('profiles').insert({
        'id': user.id,
        'name': fullName,
      });
      _fullName = fullName;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
    await fetchProfile();
    notifyListeners();
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    _user = null;
    _fullName = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final response =
        await _client
            .from('profiles')
            .select('name')
            .eq('id', userId)
            .single();

    _fullName = response['name'];
    notifyListeners();
  }
}
