// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _items.fold(
    0, 
    (sum, item) => sum + (item.product.price * item.quantity)
  );
  
  bool get isEmpty => _items.isEmpty;

  CartProvider() {
    _loadCart(); // Load cart on app start
  }

  
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart');
    
    if (cartData != null && cartData.isNotEmpty) {
      try {
        final List<dynamic> data = json.decode(cartData);
        _items = data.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      } catch (e) {
        print('Error loading cart: $e');
      }
    }
  }

  /// Save cart to SharedPreferences
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(
      _items.map((item) => item.toJson()).toList()
    );
    await prefs.setString('cart', data);
  }

  /// Add product to cart
  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id
    );
    
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    _saveCart();
    notifyListeners(); // ✅ Tells HomeScreen to update badge
  }

  /// Remove product from cart
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    _saveCart();
    notifyListeners();
  }

  /// Update quantity
  void updateQuantity(Product product, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  /// Clear cart
  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  /// Check if product is in cart
  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  /// Get quantity of product in cart
  int getQuantity(Product product) {
    //  Properly checks if item exists before creating a dummy
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      return _items[index].quantity;
    }
    return 0; // Return 0 if not found
  }
}