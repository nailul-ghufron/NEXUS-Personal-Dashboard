# NEXUS - Personal Dashboard 🚀

![NEXUS Banner](https://img.shields.io/badge/Design-Dark_Futuristic_Glassmorphism-9333EA?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

NEXUS adalah aplikasi dasbor personal mahasiswa yang dirancang dengan estetika **Dark Futuristic Glassmorphism**. Aplikasi ini mengintegrasikan produktivitas tingkat lanjut dengan kecerdasan buatan untuk membantu mahasiswa mengelola jadwal kuliah, tugas, dan fokus harian dalam satu ekosistem yang premium.

## ✨ Fitur Utama

*   **🌌 Dark Futuristic UI**: Antarmuka transparan berbasis glassmorphism dengan palet warna Lavender dan Violet yang memanjakan mata.
*   **🤖 AI Insight (Gemini AI)**: Ringkasan catatan otomatis dan saran produktivitas cerdas menggunakan integrasi Gemini 1.5 Flash.
*   **📡 Supabase Backend**: Sinkronisasi data real-time, autentikasi aman, dan persistensi database PostgreSQL.
*   **💾 Offline Persistence**: Dukungan cache lokal menggunakan Hive, memastikan data tetap tersedia meski tanpa koneksi internet.
*   **🔔 Smart Notifications**: Pengingat jadwal kuliah dan tugas secara otomatis melalui integrasi `flutter_local_notifications`.
*   **⏱️ Premium Pomodoro**: Timer fokus yang terintegrasi di bar navigasi bawah untuk meningkatkan konsentrasi.
*   **📅 Schedule & Task Management**: Manajemen jadwal kuliah mingguan dan daftar tugas harian yang interaktif.

## 🛠️ Tech Stack

*   **Frontend**: [Flutter](https://flutter.dev) (Dart)
*   **State Management**: [Riverpod 3.0](https://riverpod.dev)
*   **Backend**: [Supabase](https://supabase.com) (PostgreSQL & Auth)
*   **Local Storage**: [Hive](https://pub.dev/packages/hive)
*   **AI Engine**: [Google Generative AI](https://ai.google.dev/) (Gemini)
*   **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
*   **Design**: Vanilla CSS-like styling in Flutter with Glassmorphism components.

## 🏗️ Arsitektur Proyek

Proyek ini menggunakan pendekatan **Feature-First Architecture** untuk skalabilitas dan pemeliharaan yang mudah:

```text
lib/
├── app/                # Konfigurasi Router & Global Providers
├── core/               # Konstanta, Tema, & Reusable Widgets
├── features/           # Modul fitur (Auth, Today, Schedule, Checklist, Notes, AI)
│   ├── data/           # Repositories & API Services
│   ├── domain/         # Models & Entities
│   └── presentation/   # Screens & UI Components
└── shared/             # Services & Navigation bersama
```

## 🚀 Cara Memulai

### Prasyarat
*   Flutter SDK (Versi terbaru)
*   Akun Supabase
*   API Key Gemini (Google AI Studio)

### Instalasi
1. Clone repositori:
   ```bash
   git clone https://github.com/nailul-ghufron/NEXUS-Personal-Dashboard.git
   ```
2. Instal dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan build runner:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 📊 Database Schema

Aplikasi ini menggunakan tabel-tabel berikut di Supabase:
*   `profiles`: Data mahasiswa.
*   `schedules`: Jadwal kuliah dan kegiatan Ma'had.
*   `checklist_items`: Tugas harian dan mingguan.
*   `notes`: Catatan personal.

*Skrip SQL lengkap tersedia di file `supabase_schema.sql`.*

## 🛡️ Monitoring
Aplikasi ini sudah terintegrasi dengan **Sentry** untuk pemantauan error secara real-time dan audit performa untuk memastikan pengalaman pengguna yang mulus pada 60 FPS.

---

**Dikembangkan oleh [Nailul Ghufron](https://github.com/nailul-ghufron)**  
*Mewujudkan ekosistem produktivitas mahasiswa yang lebih cerdas dan futuristik.*
