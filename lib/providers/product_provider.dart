import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service_products.dart';

// ============================================================================
// 📍 [FILE 3/5: product_provider.dart] -> POIN 3A: STATE & NOTIFIER
// 🗣️ BACA: "ProductProvider mengelola list produk dan status loading, lalu
//           memanggil notifyListeners() setiap ada perubahan data agar UI update."
// ============================================================================
class ProductProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();
  List<Product> _products = [];
  List<String> _categories = [];
  bool _loading = false;
  String _selectedCategory = 'All';

  List<Product> get products => _products;
  List<String> get categories => _categories;
  bool get loading => _loading;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchProducts() async {
    _loading = true;
    notifyListeners();
    try {
      _products = (await _api.getAllProducts()).products;
    } catch (e) {
      debugPrint("Error fetch products: $e");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = ['All', ...await _api.getCategoryList()];
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch categories: $e");
    }
  }

  // ============================================================================
  // 📍 [FILE 3/5: product_provider.dart] -> POIN 3B: SEARCH STATE
  // 🗣️ BACA: "Fungsi searchProducts memanggil endpoint search di API, lalu
  //           mengganti list produk dengan hasil cari dan memanggil notifyListeners()."
  // ============================================================================
  Future<void> searchProducts(String query) async {
    _selectedCategory = 'All';
    if (query.isEmpty) return fetchProducts();
    _loading = true;
    notifyListeners();
    try {
      _products = (await _api.searchProducts(query)).products;
    } catch (e) {
      debugPrint("Error search: $e");
    }
    _loading = false;
    notifyListeners();
  }

  // ============================================================================
  // 📍 [FILE 3/5: product_provider.dart] -> POIN 3C: FILTER KATEGORI
  // 🗣️ BACA: "Fungsi filterByCategory memfilter katalog produk sesuai pilihan
  //           kategori user di ChoiceChip."
  // ============================================================================
  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    if (category == 'All') return fetchProducts();
    _loading = true;
    notifyListeners();
    try {
      _products = (await _api.getProductsByCategory(category)).products;
    } catch (e) {
      debugPrint("Error filter category: $e");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> addProduct(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final item = await _api.addProduct(data);
      _products.insert(0, item);
      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final item = await _api.updateProduct(id, data);
      final i = _products.indexWhere((p) => p.id == id);
      if (i != -1) _products[i] = item;
      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final deleted = await _api.deleteProduct(id);
      if (deleted) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      }
      return deleted;
    } catch (_) {
      return false;
    }
  }
}
