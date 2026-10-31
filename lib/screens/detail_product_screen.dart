import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service_products.dart';

const _ink = Color(0xFF35334A), _muted = Color(0xFF89869A);

// ============================================================================
// 📍 [FILE 5/5: detail_product_screen.dart] -> POIN 5A: PARAMETER ID
// 🗣️ BACA: "DetailProductScreen menerima parameter 'id' dari katalog untuk
//           menampilkan rincian barang yang dipilih."
// ============================================================================
class DetailProductScreen extends StatelessWidget {
  final String id;
  const DetailProductScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFAF8FC),
    appBar: AppBar(
      backgroundColor: const Color(0xFFFAF8FC),
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Detail produk',
        style: TextStyle(
          color: _ink,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
    ),
    // ========================================================================
    // 📍 [FILE 5/5: detail_product_screen.dart] -> POIN 5B: FUTUREBUILDER
    // 🗣️ BACA: "FutureBuilder memanggil getProduct(id) untuk memuat data detail
    //           secara async dan menangani status loading, error, dan datanya."
    // ========================================================================
    body: FutureBuilder<Product>(
      future: ApiServiceProducts().getProduct(int.parse(id)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFB8A4E8)),
          );
        if (snapshot.hasError || !snapshot.hasData)
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Detail produk belum bisa dimuat. Coba lagi nanti.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted),
              ),
            ),
          );
        final p = snapshot.data!;
        final discount = p.discountPercentage > 0;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================================================
              // 📍 [FILE 5/5: detail_product_screen.dart] -> POIN 5C: UI DETAIL
              // 🗣️ BACA: "UI menampilkan foto CachedNetworkImage, rating bintang,
              //           badge diskon, harga, serta deskripsi spesifikasi produk."
              // ==============================================================
              Container(
                height: 300,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF0EAF8), Color(0xFFE7F2EE)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: p.thumbnail,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFB8A4E8),
                          ),
                        ),
                        errorWidget: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Color(0xFFB9AEC9),
                          ),
                        ),
                      ),
                    ),
                    if (discount)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3C7C7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'HEMAT ${p.discountPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Color(0xFF8C4D59),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  _Pill(
                    Icons.category_outlined,
                    p.category.replaceAll('-', ' '),
                    const Color(0xFFE8DFFD),
                    const Color(0xFF6D588F),
                  ),
                  if (p.brand.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: _Pill(
                        Icons.auto_awesome_outlined,
                        p.brand,
                        const Color(0xFFDDF0E9),
                        const Color(0xFF4F806F),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                p.title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFE8B65A),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    p.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'rating pelanggan',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                  const Spacer(),
                  Icon(
                    p.stock > 0
                        ? Icons.inventory_2_outlined
                        : Icons.remove_shopping_cart_outlined,
                    color: p.stock > 0
                        ? const Color(0xFF6E9F85)
                        : const Color(0xFFD77D8A),
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    p.stock > 0 ? 'Stok ${p.stock}' : 'Stok habis',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1DE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HARGA',
                      style: TextStyle(
                        color: Color(0xFFAA8B66),
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$ ${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (discount) ...[
                          const SizedBox(width: 9),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '${(p.price / (1 - p.discountPercentage / 100)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tentang produk',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                p.description,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 14,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F2EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_florist_rounded,
                      color: Color(0xFF6E9F85),
                      size: 23,
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Pilihan manis untuk menemani harimu.',
                        style: TextStyle(
                          color: Color(0xFF4F806F),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg, fg;
  const _Pill(this.icon, this.label, this.bg, this.fg);
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 180),
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: fg),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
