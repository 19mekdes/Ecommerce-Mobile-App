import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Getters
  List<Product> get products => _filteredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  /// Load all products from API
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _apiService.getProducts();
      _filteredProducts = _allProducts;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _apiService.getCategories();
      _categories.insert(0, 'All');
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading categories: $e');
    }
  }

  /// Refresh all data (pull to refresh)
  Future<void> refreshProducts() async {
    await loadProducts();
    await loadCategories();
  }

  /// Filter products by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    
    if (category == 'All') {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts
          .where((p) => p.category == category)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      _applySearch();
    }
    
    notifyListeners();
  }

  /// Search products by title
  void searchProducts(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  /// Apply search filter
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      if (_selectedCategory == 'All') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((p) => p.category == _selectedCategory)
            .toList();
      }
    } else {
      _filteredProducts = _filteredProducts
          .where((p) => p.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  /// Get product by ID
  Product? getProductById(int id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _filteredProducts = _allProducts;
    notifyListeners();
  }
}