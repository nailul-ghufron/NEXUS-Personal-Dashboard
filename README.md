<div align="center">

# ✦ NEXUS — Personal Dashboard

<img src="AppIcon.png" width="120" alt="NEXUS Icon"/>

### *Ekosistem Produktivitas Mahasiswa Generasi Berikutnya*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-%2302569B?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-%230175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-3.0-4FC3F7?style=for-the-badge)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

![Design](https://img.shields.io/badge/Design-Dark_Futuristic_Glassmorphism-9333EA?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-blueviolet?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-success?style=for-the-badge)

</div>

---

## 📖 Tentang Proyek

**NEXUS** adalah aplikasi dasbor personal untuk mahasiswa yang dibangun dengan Flutter, mengusung estetika premium **Dark Futuristic Glassmorphism**. Alih-alih membuka banyak aplikasi secara terpisah, NEXUS menyatukan semua kebutuhan produktivitas harian — jadwal, tugas, catatan, fokus, dan wawasan AI — ke dalam satu ekosistem terintegrasi yang cepat dan modern.

> *"Mewujudkan ekosistem produktivitas mahasiswa yang lebih cerdas dan futuristik."*

---

## ✨ Fitur Lengkap

### 🏠 Home Dashboard (Today)
Halaman utama yang berfungsi sebagai pusat ringkasan harian secara **real-time**:
- Kartu **"Kelas Berikutnya"** yang otomatis menampilkan jadwal terdekat hari ini.
- Kartu **"Progres Tugas Harian"** dengan toggle langsung dari halaman beranda.
- Ringkasan status produktivitas keseluruhan.

### 📅 Schedule Manager
Manajemen jadwal kuliah dan kegiatan lengkap:
- Tampilan **Harian**, **Mingguan**, dan **Kalender** interaktif.
- Tambah, **edit**, dan **hapus** jadwal dengan antarmuka pop-up yang responsif.
- Kartu jadwal dengan indikator warna dinamis dan detail lokasi.

### ✅ Checklist & Task Manager
Sistem tugas harian dan mingguan yang canggih:
- Filter berdasarkan kategori: **Harian**, **Mingguan**, dan **Custom**.
- **Progress Ring** visual untuk memantau persentase penyelesaian.
- **Auto-reset** tugas harian tepat pukul 00:00 tengah malam.
- Navigasi tanggal untuk melihat tugas di hari tertentu.

### 📝 Smart Notes
Sistem pencatatan yang fleksibel dan full-screen:
- Grid catatan dengan pratinjau isi yang rapi.
- **Full-screen editor** dengan tint warna personal dan field tag.
- **AI Summary** terintegrasi per catatan menggunakan Multi-Model AI.
- **Auto-save** saat keluar dari editor tanpa kehilangan data.

### 🤖 AI Insight (Multi-Model Provider)
Sistem AI canggih dengan arsitektur **API Load Balancing & Key Rotation**:
- **Key Pool** dari 3 penyedia berbeda: Google Gemini, OpenRouter, dan Grok (xAI).
- **Auto-Rotation**: Jika satu key kena *rate limit* (error 429), sistem otomatis beralih ke key berikutnya tanpa terasa oleh pengguna.
- **Smart Caching**: Hasil AI di-cache lokal (Hive), sehingga pertanyaan yang sama tidak memanggil API ulang.
- Menghasilkan ringkasan catatan dan saran produktivitas cerdas.

### ⏱️ Pomodoro Timer Premium
Timer fokus terintegrasi di navigasi bawah:
- Mode **Focus**, **Short Break**, dan **Long Break**.
- Tampilan timer persistent di navigation bar agar tetap terlihat di semua halaman.
- Suara alarm yang dapat disesuaikan.

### 👤 Profile Manager
Manajemen profil pengguna yang lengkap:
- **Upload/ganti foto profil** langsung dari galeri.
- **Kompresi otomatis** gambar (512x512 px, 80% quality) sebelum diunggah untuk menjaga performa.
- Foto disimpan di Supabase Storage dan tersinkronisasi ke semua perangkat.
- Tombol logout yang aman.

### 🔔 Smart Notifications
Sistem notifikasi cerdas:
- Pengingat jadwal kuliah dan tugas secara otomatis.
- Dibangun menggunakan `flutter_local_notifications` dengan dukungan waktu zona lokal.

---

## 🏗️ Arsitektur & Teknologi

### Design Pattern
Proyek ini menggunakan **Feature-First Architecture** yang dikombinasikan dengan **Clean Architecture** (Data → Domain → Presentation) untuk setiap fitur, memastikan kode yang terpisah, mudah diuji, dan mudah diperluas.

```
lib/
├── app/
│   ├── providers/          # Global UI providers (FAB, filter state, dll.)
│   └── router.dart         # GoRouter & Auth Guard configuration
│
├── core/
│   ├── constants/          # Warna, tema (NexusColors, NexusTheme)
│   ├── database/           # LocalDbService (Hive wrapper + Sync Queue)
│   ├── theme/              # Material ThemeData global
│   └── widgets/            # GlassCard, GlassButton, GlassInput (reusable)
│
├── features/
│   ├── ai_insight/         # Gemini Service + Multi-Model Key Rotation
│   ├── auth/               # Login Screen, Auth Providers, Supabase Auth Repo
│   ├── checklist/          # Task Manager (Data, Domain, Presentation)
│   ├── notes/              # Smart Notes + Full-Screen Editor
│   ├── notifications/      # Local Notification Service
│   ├── pomodoro/           # Pomodoro Timer Screen & Logic
│   ├── profile/            # Profile Screen + Avatar Upload
│   ├── schedule/           # Schedule Manager (Calendar, Day, Week view)
│   └── today/              # Home Dashboard (NextClass, TodayHabits cards)
│
└── shared/
    ├── navigation/         # MainShell, BottomNav, FAB logic
    ├── providers/          # Repository Providers (DI layer)
    └── services/           # NotificationService
```

### Tech Stack

| Layer | Teknologi | Versi |
|---|---|---|
| **Framework** | Flutter | 3.x (Dart 3.x) |
| **State Management** | Riverpod + Riverpod Annotation | `^3.3.1` / `^4.0.2` |
| **Backend** | Supabase (PostgreSQL, Auth, Storage) | `^2.10.1` |
| **Navigasi** | GoRouter | `^17.2.2` |
| **Local Storage** | Hive Flutter | `^1.1.0` |
| **AI Engine** | Google Generative AI (Gemini) | `^0.4.5` |
| **HTTP Client** | Dart `dart:io` (HttpClient) | Built-in |
| **Kode Generator** | Freezed + JsonSerializable + RiverpodGenerator | - |
| **Desain** | Google Fonts (Inter) | `^8.0.2` |
| **Ikon** | Lucide Icons Flutter | `^3.1.13` |
| **Gambar** | CachedNetworkImage + ImagePicker | `^3.4.1` / `^1.2.1` |
| **Kalender** | TableCalendar | `^3.2.0` |
| **Animasi** | Flutter Animate | `^4.5.2` |
| **Monitoring** | Sentry Flutter | `^8.11.0` |
| **Notifikasi** | FlutterLocalNotifications | `^21.0.0` |
| **Audio** | AudioPlayers | `^6.6.0` |

---

## ⚙️ Sistem Offline & Sinkronisasi

NEXUS memiliki sistem **Offline Persistence** yang handal menggunakan strategi **Cache-First with Background Sync**:

1.  **Instan Load (0ms):** Saat aplikasi dibuka, data langsung diambil dari cache Hive lokal. Tidak ada *loading* yang menunggu internet.
2.  **Background Refresh:** Tepat setelah UI muncul, data segar diambil dari Supabase secara diam-diam di background dan memperbarui layar tanpa gangguan.
3.  **Offline Queue:** Aksi yang dilakukan saat offline (tambah/edit/hapus) disimpan dalam antrian (`sync_queue`). Antrian ini otomatis dieksekusi ke server saat koneksi tersedia kembali.
4.  **Conflict Resolution — "Server Wins":** Jika ada perbedaan data antara HP dan server, data dari Supabase (server) selalu menjadi sumber kebenaran (*source of truth*).

---

## 🚀 Cara Memulai

### Prasyarat

-   Flutter SDK (≥ 3.x)
-   Akun [Supabase](https://supabase.com) (gratis)
-   API Key dari [Google AI Studio](https://aistudio.google.com/) (Gemini)
-   *(Opsional)* API Key dari [OpenRouter](https://openrouter.ai/) dan [Grok (xAI)](https://x.ai/) untuk Key Rotation

### 1. Clone Repositori

```bash
git clone https://github.com/nailul-ghufron/NEXUS-Personal-Dashboard.git
cd NEXUS-Personal-Dashboard-2
```

### 2. Setup Supabase

1.  Buat proyek baru di [supabase.com](https://supabase.com).
2.  Jalankan skrip SQL berikut di **SQL Editor** Supabase untuk membuat skema database:

```sql
-- Tabel Jadwal
CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  type TEXT DEFAULT 'campus',
  location TEXT,
  start_time TEXT NOT NULL,
  end_time TEXT,
  day_of_week INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabel Tugas
CREATE TABLE checklist_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  category TEXT DEFAULT 'daily',
  sort_order INT DEFAULT 0,
  due_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabel Catatan
CREATE TABLE notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT DEFAULT '',
  tint_color INT DEFAULT 0,
  tags TEXT[],
  last_modified TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Aktifkan Row Level Security (RLS) agar setiap user hanya melihat datanya sendiri
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

-- Buat kebijakan akses untuk setiap tabel
CREATE POLICY "User owns their data" ON schedules FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "User owns their data" ON checklist_items FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "User owns their data" ON notes FOR ALL USING (auth.uid() = user_id);
```

3.  Buat **Storage Bucket** bernama `profiles` (set **Public**) untuk foto profil.

```sql
INSERT INTO storage.buckets (id, name, public) VALUES ('profiles', 'profiles', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING (bucket_id = 'profiles');
CREATE POLICY "User Upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'profiles');
```

### 3. Konfigurasi API Keys

Edit file `lib/app/providers/` dan `lib/features/ai_insight/data/gemini_service.dart` untuk mengisi API key Anda, atau buat file `.env` jika menggunakan `flutter_dotenv`.

Secara default, konfigurasi disimpan di:
- **Supabase URL & Anon Key**: `lib/main.dart`
- **AI Key Pool**: `lib/features/ai_insight/data/gemini_service.dart`

### 4. Instalasi Dependensi & Build

```bash
# Install semua package
flutter pub get

# Generate kode untuk Riverpod, Freezed, dan JSON Serializable
flutter pub run build_runner build --delete-conflicting-outputs

# Jalankan aplikasi
flutter run
```

### 5. Build APK (Rilis)

```bash
flutter build apk --release
```

APK akan tersedia di: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🗄️ Skema Database

```
┌─────────────────────────────────────────┐
│                  users                  │
│         (Supabase Auth built-in)        │
│  id · email · metadata (avatar_url)     │
└────────────────────┬────────────────────┘
                     │ (user_id FK)
          ┌──────────┼──────────────┐
          │          │              │
    ┌─────▼────┐ ┌───▼────┐ ┌─────▼──────┐
    │schedules │ │ notes  │ │  checklist │
    │          │ │        │ │   _items   │
    │id        │ │id      │ │id          │
    │title     │ │title   │ │title       │
    │type      │ │content │ │is_completed│
    │location  │ │tint    │ │category    │
    │start_time│ │tags    │ │sort_order  │
    │end_time  │ │last_mod│ │due_date    │
    │day_of_wk │ │        │ │            │
    └──────────┘ └────────┘ └────────────┘
```

---

## 🛡️ Monitoring & Error Tracking

Aplikasi terintegrasi dengan **Sentry Flutter** untuk:
- Pemantauan error secara *real-time* di production.
- Audit performa (*performance tracing*) untuk memastikan UI berjalan di **60 FPS**.
- Laporan crash otomatis beserta *stack trace* yang lengkap.

Ganti DSN Sentry Anda di `lib/main.dart`:
```dart
options.dsn = 'YOUR_SENTRY_DSN_HERE';
```

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Ikuti langkah berikut:

1.  **Fork** repositori ini.
2.  Buat **branch** fitur baru: `git checkout -b feature/nama-fitur-baru`
3.  **Commit** perubahan Anda: `git commit -m 'feat: tambahkan fitur X'`
4.  **Push** ke branch: `git push origin feature/nama-fitur-baru`
5.  Buat **Pull Request**.

---

## 📄 Lisensi

Didistribusikan di bawah Lisensi MIT. Lihat file `LICENSE` untuk informasi lebih lanjut.

---

<div align="center">

**Dikembangkan dengan ❤️ oleh [Nailul Ghufron](https://github.com/nailul-ghufron)**

*Universitas Islam Negeri Maulana Malik Ibrahim Malang*

⭐ **Jika proyek ini bermanfaat, berikan bintang di GitHub!** ⭐

</div>
