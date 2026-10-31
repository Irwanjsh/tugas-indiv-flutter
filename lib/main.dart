import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/product_provider.dart';
import 'models/product_model.dart';
import 'screens/list_product_screen.dart';
import 'screens/detail_product_screen.dart';
import 'screens/form_product_screen.dart';

// ============================================================================
// 📍 [FILE 1/5: main.dart] -> POIN 1A: ROOT PROVIDER
// 🗣️ BACA: "Di main.dart, aplikasi dibungkus ChangeNotifierProvider agar state
//           produk bisa diakses secara global di seluruh halaman."
// ============================================================================
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

// ============================================================================
// 📍 [FILE 1/5: main.dart] -> POIN 1B: ROUTING GOROUTER
// 🗣️ BACA: "Navigasi memakai GoRouter: rute '/' untuk katalog utama, dan
//           '/detail/:id' membawa ID untuk membuka halaman detail."
// ============================================================================
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ListProductScreen()),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) =>
          DetailProductScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const FormProductScreen(),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) =>
          FormProductScreen(product: state.extra as Product?),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mellow Market',
      debugShowCheckedModeBanner: false,
      // ======================================================================
      // 📍 [FILE 1/5: main.dart] -> POIN 1C: TEMA WARNA PASTEL
      // 🗣️ BACA: "Tema menggunakan Material 3 dengan warna Pastel Purple
      //           (0xFFAA95DA) dan background off-white yang lembut."
      // ======================================================================
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFAA95DA)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
