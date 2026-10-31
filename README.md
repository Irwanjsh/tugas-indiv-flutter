# Mellow Market — Flutter Product Catalog

Aplikasi katalog produk berbasis mobile menggunakan framework Flutter yang terintegrasi secara real-time dengan REST API publik dari [DummyJSON](https://dummyjson.com/docs/products). Aplikasi dirancang dengan antarmuka bertema warna pastel yang lembut (*Soft Lavender*, *Pastel Purple*, dan *Off-White*).

---

## 📹 Video Presentasi & Live Demo
Tonton video presentasi kode dan pengujian aplikasi langsung di perangkat HP fisik melalui tautan YouTube berikut:
- **Tautan YouTube:** [Tonton Video Demo Mellow Market di YouTube](https://youtu.be/gqEANhPqABc?si=VHtLwzjYo9DbBSRT)
- **Nama Pengembang:** [Isi Nama Anda]
- **NIM:** [Isi NIM Anda]
- **Mata Kuliah:** Pemrograman Perangkat Bergerak (Mobile Programming)

---

## ✨ Fitur Utama
1. **Katalog Produk Dinamis (Grid View):** Menampilkan seluruh katalog produk dalam layout dua kolom responsif dengan palet warna pastel yang nyaman dipandang.
2. **Filter Kategori (Choice Chips):** Memfilter produk secara instan berdasarkan kategori bawaan API DummyJSON.
3. **Pencarian Real-Time (Debounced Search):** Kolom pencarian yang reaktif dan otomatis memperbarui data dengan jeda debounce 350ms untuk efisiensi request.
4. **Halaman Detail Produk:** Menampilkan informasi lengkap item saat diklik: foto resolusi tinggi ber-cache, rating pengguna, persentase diskon, harga, stok, dan deskripsi produk.
5. **Manajemen State Terpusat:** Menggunakan Provider (`ChangeNotifier`) untuk sinkronisasi state aplikasi yang bersih dan modular.

---

## 🛠️ Teknologi & Pustaka (Tech Stack)
- **Framework:** Flutter (SDK Dart 3.x)
- **Arsitektur State:** `provider`
- **HTTP Client:** `dio`
- **Routing & Navigasi:** `go_router`
- **Image Caching:** `cached_network_image`
- **REST API:** `https://dummyjson.com/products`

---

## 🚀 Cara Menjalankan Proyek Secara Lokal

1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/[USERNAME_ANDA]/[NAMA_REPO].git
   cd [NAMA_REPO]/toko
   ```

2. **Pasang seluruh dependensi:**
   ```bash
   flutter pub get
   ```

3. **Hubungkan perangkat fisik (HP Android) via USB & aktifkan USB Debugging, lalu jalankan:**
   ```bash
   flutter run
   ```

---

## 📄 Panduan Naskah Video
Naskah lengkap presentasi, cue card, dan petunjuk aksi layar tersedia di berkas [`NASKAH_VIDEO_PRESENTASI.md`](./NASKAH_VIDEO_PRESENTASI.md).
