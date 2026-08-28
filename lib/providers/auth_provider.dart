import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // 🔐 Private state
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  // 📢 Public getters
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;

  AuthProvider() {
    _loadSavedToken(); // Load token on app start
  }

  /// Load saved token from SharedPreferences
  Future<void> _loadSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    
    if (_token != null) {
      await _loadUser(); // Auto-login if token exists
    }
    notifyListeners();
  }

  /// Load user data from API
  Future<void> _loadUser() async {
    try {
      _user = await _apiService.getUser(1); // Using default user ID 1
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Login user
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Get token from API
      _token = await _apiService.login(username, password);
      
      // 2. Save token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      
      // 3. Load user data
      await _loadUser();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _token = null;
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    notifyListeners();
  }
}