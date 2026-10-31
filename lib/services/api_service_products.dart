import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiServiceProducts {
  // ============================================================================
  // 📍 [FILE 2/5: api_service_products.dart] -> POIN 2A: HTTP CLIENT DIO
  // 🗣️ BACA: "Untuk komunikasi API, kita memakai HTTP client Dio dengan
  //           Base URL ke dummyjson.com dan timeout 15 detik."
  // ============================================================================
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // SORT: https://dummyjson.com/products?sortBy=price&order=desc
  Future<ProductsResponse> sortProducts(String sortBy, String order) async {
    final res = await _dio.get(
      '/products',
      queryParameters: {'sortBy': sortBy, 'order': order},
    );
    return ProductsResponse.fromJson(res.data);
  }

  // ============================================================================
  // 📍 [FILE 2/5: api_service_products.dart] -> POIN 2B: GET ALL
  // 🗣️ BACA: "Fungsi getAllProducts memanggil endpoint '/products' untuk
  //           mengambil seluruh katalog produk."
  // ============================================================================
  Future<ProductsResponse> getAllProducts({
    int limit = 0,
    int skip = 0,
  }) async {
    final res = await _dio.get(
      '/products',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return ProductsResponse.fromJson(res.data);
  }

  // ============================================================================
  // 📍 [FILE 2/5: api_service_products.dart] -> POIN 2C: GET SINGLE PRODUCT
  // 🗣️ BACA: "Fungsi getProduct mengambil detail satu produk spesifik
  //           berdasarkan ID melalui endpoint '/products/$id'."
  // ============================================================================
  Future<Product> getProduct(int id) async {
    final res = await _dio.get('/products/$id');
    return Product.fromJson(res.data);
  }

  // ============================================================================
  // 📍 [FILE 2/5: api_service_products.dart] -> POIN 2D: SEARCH
  // 🗣️ BACA: "Fungsi searchProducts memanfaatkan endpoint '/products/search?q='
  //           untuk fitur pencarian sesuai kata kunci user."
  // ============================================================================
  Future<ProductsResponse> searchProducts(String query) async {
    final res = await _dio.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    return ProductsResponse.fromJson(res.data);
  }

  // 4. GET CATEGORY LIST
  Future<List<String>> getCategoryList() async {
    final res = await _dio.get('/products/category-list');
    return (res.data as List).map((e) => e.toString()).toList();
  }

  // 5. GET BY CATEGORY
  Future<ProductsResponse> getProductsByCategory(String category) async {
    final res = await _dio.get('/products/category/$category');
    return ProductsResponse.fromJson(res.data);
  }

  // 6. POST (ADD)
  Future<Product> addProduct(Map<String, dynamic> data) async {
    final res = await _dio.post('/products/add', data: data);
    return Product.fromJson(res.data);
  }

  // 7. PUT (UPDATE)
  Future<Product> updateProduct(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/products/$id', data: data);
    return Product.fromJson(res.data);
  }

  // 8. DELETE
  Future<bool> deleteProduct(int id) async {
    final res = await _dio.delete('/products/$id');
    return res.data['isDeleted'] ?? false;
  }
}
