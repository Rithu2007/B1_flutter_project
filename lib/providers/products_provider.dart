import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products.dart';
import '../services/storage_service.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  Set<String> _favoriteIds = {};
  String _searchQuery = '';
  final List<String> _recentSearches = [
    'Milk',
    'Apples',
    'Paneer',
    'Basmati Rice',
    'Tomatoes',
  ];

  ProductsProvider() {
    _allProducts = List.from(mockProducts);
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoriteIds = StorageService.getFavorites();
    notifyListeners();
  }

  List<Product> get allProducts => _allProducts;
  List<Product> get popularProducts =>
      _allProducts.where((p) => p.isPopular).toList();
  List<Product> get dealsProducts =>
      _allProducts.where((p) => p.discount >= 15).toList();
  List<String> get recentSearches => _recentSearches;
  String get searchQuery => _searchQuery;

  List<Product> get favoriteProducts =>
      _allProducts.where((p) => _favoriteIds.contains(p.id)).toList();

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    StorageService.saveFavorites(_favoriteIds);
    notifyListeners();
  }

  void addRecentSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _recentSearches.remove(trimmed);
    _recentSearches.insert(0, trimmed);
    if (_recentSearches.length > 8) {
      _recentSearches.removeLast();
    }
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  List<Product> searchProducts(String query) {
    _searchQuery = query.trim().toLowerCase();
    if (_searchQuery.isEmpty) return [];

    return _allProducts.where((product) {
      final nameMatches = product.name.toLowerCase().contains(_searchQuery);
      final catMatches =
          product.category.toLowerCase().contains(_searchQuery);
      final descMatches =
          product.description.toLowerCase().contains(_searchQuery);
      return nameMatches || catMatches || descMatches;
    }).toList();
  }

  List<Product> getProductsByCategory(String categoryId) {
    final catId = categoryId.toLowerCase();
    return _allProducts
        .where((product) => product.category.toLowerCase() == catId)
        .toList();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
