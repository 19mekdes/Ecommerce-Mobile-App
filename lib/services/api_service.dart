import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

/// Thrown when the API can't be reached (DNS failure, no internet, timeout).
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  // Base URL for Fake Store API
  static const String baseUrl =
      'https://corsproxy.io/?https://fakestoreapi.com';

  // Give the request time to complete before failing with a clear message
  static const Duration _timeout = Duration(seconds: 12);

  /// (DNS errors, offline, server unreachable) into a friendly [ApiException].
  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } on TimeoutException {
      throw ApiException(
        'The server took too long to respond. Check your internet connection and try again.',
      );
    } on http.ClientException {
      throw ApiException(
        'Cannot reach the server ($baseUrl). Check your internet connection and try again.',
      );
    }
  }

  // ============ AUTHENTICATION ============

  /// Login user - returns JWT token
  Future<String> login(String username, String password) async {
    final response = await _send(
      () => http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      ),
    );

    // The Fake Store API returns 201 (Created) for successful logins.
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body)['token'];
    } else {
      throw ApiException(
        'Invalid username or password (HTTP ${response.statusCode}). '
        'Please check your credentials and try again.',
      );
    }
  }

  // ============ PRODUCTS ============

  /// Get all products
  Future<List<Product>> getProducts() async {
    final response = await _send(
      () => http.get(Uri.parse('$baseUrl/products')),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  /// Get single product by ID
  Future<Product> getProduct(int id) async {
    final response = await _send(
      () => http.get(Uri.parse('$baseUrl/products/$id')),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Product not found');
    }
  }

  /// Get all categories
  Future<List<String>> getCategories() async {
    final response = await _send(
      () => http.get(Uri.parse('$baseUrl/products/categories')),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // ============ USERS ============

  /// Get user by ID
  Future<User> getUser(int id) async {
    final response = await _send(
      () => http.get(Uri.parse('$baseUrl/users/$id')),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('User not found');
    }
  }
}
