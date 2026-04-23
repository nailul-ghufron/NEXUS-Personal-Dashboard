# Langkah Selanjutnya: Nexus Personal Dashboard 🚀

Setelah fondasi UI dan arsitektur dasar selesai, berikut adalah peta jalan (roadmap) untuk mengubah prototipe ini menjadi aplikasi yang berfungsi penuh:

## Fase 1: Integrasi Firebase & Backend 🔧
Tujuan: Menghubungkan aplikasi dengan database dan autentikasi nyata.

1.  **Konfigurasi Firebase**: Jalankan perintah `flutterfire configure` di terminal untuk mendaftarkan aplikasi dan membuat file `lib/firebase_options.dart`.
2.  **Inisialisasi Firebase**: Update `lib/main.dart` untuk memanggil `Firebase.initializeApp()`.
3.  **Autentikasi**: Implementasi logika Login dan Register menggunakan `firebase_auth`. Hubungkan tombol login di `LoginScreen` ke `AuthRepository`.

## Fase 2: Data Modeling & Repositories 📊
Tujuan: Menentukan struktur data yang akan disimpan di Firestore.

1.  **Create Models**: Buat class model (menggunakan `freezed` jika memungkinkan) untuk:
    *   `ScheduleItem`: (id, title, startTime, endTime, type, location)
    *   `ChecklistItem`: (id, title, isCompleted, priority, dueDate)
    *   `Note`: (id, title, content, tint, lastModified)
2.  **Repositories**: Implementasikan class Repository untuk melakukan operasi CRUD ke Firestore untuk setiap fitur.

## Fase 3: State Management (Riverpod) 🧠
Tujuan: Mengelola logika bisnis dan sinkronisasi data real-time.

1.  **Auth State**: Gunakan `StreamProvider` untuk memantau status login pengguna secara otomatis.
2.  **Data Providers**: Buat `AsyncNotifier` atau `StreamProvider` untuk mengambil data dari Firestore:
    *   `scheduleProvider`
    *   `checklistProvider`
    *   `notesProvider`
3.  **Interaktivitas**: Hubungkan UI ke provider. Contoh: Menekan checkbox di `ChecklistScreen` akan memanggil fungsi `toggleItem` di provider.

## Fase 4: Fitur Spesifik & Interaktivitas ⏱️
Tujuan: Menyelesaikan logika fitur unik aplikasi.

1.  **Pomodoro Timer**: Implementasikan logika timer di `PomodoroProvider` agar waktu benar-benar berjalan dan bisa di-pause/reset dari floating chip.
2.  **CRUD Modals**: Tambahkan BottomSheet atau Dialog untuk menambah/mengedit jadwal, tugas, dan catatan baru.
3.  **Search Logic**: Implementasikan filter pencarian pada `NotesScreen` menggunakan data dari provider.

## Fase 5: Refinement & Polish ✨
Tujuan: Memastikan kualitas premium dan performa.

1.  **Lucide Icons**: Ganti semua `MaterialIcons` sementara dengan `lucide_icons_flutter` sesuai PRD.
2.  **Lint Cleanup**: Ganti `.withOpacity()` dengan `.withValues(alpha: ...)` untuk menghilangkan warning Flutter 3.27.
3.  **Animasi**: Tambahkan transisi antar halaman dan micro-animations menggunakan `flutter_animate`.
4.  **Testing**: Tambahkan unit testing untuk logika repository dan widget testing untuk komponen core.

---
**Rekomendasi Segera:** Mulai dengan **Fase 1 (Firebase)** agar Anda bisa mulai menyimpan data nyata. Apakah Anda ingin saya membantu dengan konfigurasi Firebase atau pembuatan Data Model terlebih dahulu?
