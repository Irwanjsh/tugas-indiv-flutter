import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

// ============================================================================
// 📍 [FILE 4/5: list_product_screen.dart] -> POIN 4A: PALET WARNA PASTEL
// 🗣️ BACA: "Pada beranda, kita tentukan warna pastel seperti Off-White
//           (0xFFFAF8FC) dan teks ink lembut untuk kenyamanan mata."
// ============================================================================
const _ink = Color(0xFF35334A),
    _muted = Color(0xFF89869A),
    _bg = Color(0xFFFAF8FC);

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});
  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<ProductProvider>().fetchProducts();
      context.read<ProductProvider>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  // ============================================================================
  // 📍 [FILE 4/5: list_product_screen.dart] -> POIN 4B: DEBOUNCE SEARCH 350MS
  // 🗣️ BACA: "Fungsi _searchFor memakai Timer debounce 350ms agar request API
  //           hanya dikirim saat user berhenti mengetik, mencegah lag dan spam."
  // ============================================================================
  void _searchFor(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<ProductProvider>().searchProducts(value.trim());
    });
  }

  Future<void> _delete(Product item) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Hapus produk?'),
        content: Text('Produk “${item.title}” akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE88D9B),
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yes == true) context.read<ProductProvider>().deleteProduct(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProductProvider>();
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        backgroundColor: const Color(0xFFAA95DA),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah produk'),
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8DFFD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.local_mall_rounded,
                            color: Color(0xFF8069B6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MELLOW MARKET',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Temukan yang kamu suka',
                                style: TextStyle(
                                  color: _ink,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF55456E).withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _search,
                        onChanged: (value) {
                          _searchFor(value);
                          setState(() {});
                        },
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Cari produk favoritmu...',
                          hintStyle: const TextStyle(
                            color: _muted,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF9A86C5),
                          ),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _search.clear();
                                    _searchFor('');
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: _muted,
                                  ),
                                ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ============================================================================
            // 📍 [FILE 4/5: list_product_screen.dart] -> POIN 4C: FILTER CHOICE CHIP
            // 🗣️ BACA: "Kategori produk ditampilkan horizontal lewat ChoiceChip dengan
            //           aksen Soft Lavender (0xFFE8DFFD) saat dipilih."
            // ============================================================================
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: p.categories.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        scrollDirection: Axis.horizontal,
                        itemCount: p.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final cat = p.categories[i],
                              selected = cat == p.selectedCategory;
                          return ChoiceChip(
                            label: Text(
                              cat == 'All' ? 'Semua' : cat.replaceAll('-', ' '),
                            ),
                            selected: selected,
                            showCheckmark: false,
                            onSelected: (_) {
                              _search.clear();
                              _debounce?.cancel();
                              context.read<ProductProvider>().filterByCategory(
                                cat,
                              );
                              setState(() {});
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xFFE8DFFD),
                            side: BorderSide(
                              color: selected
                                  ? const Color(0xFFCDBCF3)
                                  : const Color(0xFFEDEAF1),
                            ),
                            labelStyle: TextStyle(
                              color: selected
                                  ? const Color(0xFF66518F)
                                  : _muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                          );
                        },
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 23, 22, 13),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Pilihan untukmu',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${p.products.length} produk',
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (p.loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFB8A4E8)),
                ),
              )
            else if (p.products.isEmpty)
              const SliverFillRemaining(hasScrollBody: false, child: _Empty())
            // ============================================================================
            // 📍 [FILE 4/5: list_product_screen.dart] -> POIN 4D: GRID & NAVIGASI
            // 🗣️ BACA: "Katalog disajikan dalam Grid 2 kolom responsif. Saat kartu
            //           diklik, onTap memicu context.push('/detail/${item.id}')."
            // ============================================================================
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final item = p.products[i];
                    return _Card(
                      item: item,
                      onTap: () => context.push('/detail/${item.id}'),
                      onEdit: () =>
                          context.push('/edit/${item.id}', extra: item),
                      onDelete: () => _delete(item),
                    );
                  }, childCount: p.products.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: .68,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Product item;
  final VoidCallback onTap, onEdit, onDelete;
  const _Card({
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: const Color(0xFFF0EAF8),
                  padding: const EdgeInsets.all(13),
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnail,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Color(0xFFC4B9D2),
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFFC4B9D2),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded, color: _ink),
                    color: Colors.white,
                    onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 9),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Color(0xFFD77D8A),
                            ),
                            SizedBox(width: 9),
                            Text('Hapus'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.replaceAll('-', ' '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9A86C5),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFE9B95F),
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          '\$ ${item.price.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF6D588F),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFC5B6DC)),
          SizedBox(height: 12),
          Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              color: _ink,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Coba kata kunci atau kategori lain.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
