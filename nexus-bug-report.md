# 🔍 NEXUS — Laporan Analisis Bug
**Tanggal Analisis:** 25 April 2026  
**Versi Proyek:** Flutter + Supabase + Riverpod 3.0  
**Analis:** Claude (Anthropic)

---

## 📊 Ringkasan Eksekutif

Aplikasi NEXUS tidak menampilkan data dari Supabase karena terdapat **2 bug kritikal yang saling berkaitan** di lapisan autentikasi. Seluruh bug ditemukan melalui analisis statis terhadap 30+ file source code. Tidak ada satu pun data yang bisa masuk atau keluar dari database selama kondisi ini belum diperbaiki.

| Severity | Jumlah |
|----------|--------|
| 🔴 Kritikal | 4 |
| 🟡 Peringatan | 3 |
| 🔵 Minor | 2 |
| **Total** | **9** |

---

## 🔴 BUG KRITIKAL

### BUG-01 — Auth Selalu Di-bypass: Data Tidak Pernah Di-fetch dengan User Nyata

**File:** `lib/app/router.dart`  
**Dampak:** Seluruh data Supabase tidak bisa diakses

**Deskripsi:**  
Router menggunakan nilai hardcoded `const bool isLoggedIn = true`. Ini berarti auth state dari Supabase tidak pernah digunakan sama sekali. Akibatnya, `currentUserProvider` mengembalikan `null` karena user belum pernah benar-benar login melalui Supabase Auth. Semua repository yang membutuhkan `user_id` gagal atau menampilkan data kosong.

**Kode Bermasalah:**
```dart
// lib/app/router.dart
redirect: (context, state) {
  const bool isLoggedIn = true; // ← HARDCODED, tidak pernah membaca Supabase
  final isLogin = state.matchedLocation == '/login';
  if (!isLoggedIn && !isLogin) return '/login';
  if (isLoggedIn && isLogin) return '/today';
  return null;
},
```

**Perbaikan:**
```dart
// Ubah router menjadi Provider agar bisa membaca Riverpod state
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/today',
    observers: [SentryNavigatorObserver()],
    redirect: (context, state) {
      final isLoggedIn = authState.value?.session != null;
      final isLogin = state.matchedLocation == '/login';
      if (!isLoggedIn && !isLogin) return '/login';
      if (isLoggedIn && isLogin) return '/today';
      return null;
    },
    routes: [ /* ... sama seperti sebelumnya */ ],
  );
});

// Di NexusApp, ganti:
// routerConfig: router
// Menjadi:
// routerConfig: ref.watch(routerProvider)
```

---

### BUG-02 — Supabase `anonKey` Tidak Valid (Bukan Format JWT)

**File:** `lib/main.dart`  
**Dampak:** Semua request ke Supabase mengembalikan error 401 Unauthorized

**Deskripsi:**  
Key yang digunakan adalah `'sb_publishable_7W6rgoLKTu5Q0qoTd8NH-A_givh9Bxb'`. Ini adalah format **publishable key** yang bukan merupakan JWT anon key yang dibutuhkan oleh Supabase Flutter SDK. Seluruh request HTTP ke Supabase akan gagal dengan status `401 Unauthorized`, sehingga tidak ada data yang bisa dibaca maupun ditulis.

Anon key Supabase yang valid selalu berbentuk JWT panjang yang dimulai dengan `eyJ...`.

**Kode Bermasalah:**
```dart
// lib/main.dart
await Supabase.initialize(
  url: 'https://mnxhkxcojjhqkeyzsjtj.supabase.co',
  anonKey: 'sb_publishable_7W6rgoLKTu5Q0qoTd8NH-A_givh9Bxb', // ← FORMAT SALAH
);
```

**Perbaikan:**
```dart
// Ambil anon key yang benar dari:
// Supabase Dashboard → Project Settings → API → "anon public" key
await Supabase.initialize(
  url: 'https://mnxhkxcojjhqkeyzsjtj.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...', // ← JWT panjang dari dashboard
);
```

> **Cara mendapatkan key yang benar:**  
> Buka [Supabase Dashboard](https://supabase.com/dashboard) → Pilih project → **Project Settings** → **API** → Salin nilai dari kolom **"anon public"**.

---

### BUG-03 — Row Level Security (RLS) Memblokir Semua Query

**File:** `supabase_schema.sql` (dikombinasikan dengan BUG-01 dan BUG-02)  
**Dampak:** Seluruh query SELECT, INSERT, UPDATE, DELETE diblokir — mengembalikan array kosong

**Deskripsi:**  
Semua tabel (`schedules`, `checklist_items`, `notes`, `profiles`) menggunakan Row Level Security dengan policy berbasis `auth.uid()`:

```sql
CREATE POLICY "Users can manage own schedules" 
  ON schedules FOR ALL 
  USING (auth.uid() = user_id);
```

Karena BUG-01 (auth di-bypass) dan BUG-02 (anon key salah), `auth.uid()` selalu bernilai `NULL` di sisi Supabase. Akibatnya semua policy ditolak dan Supabase mengembalikan **respons kosong tanpa error** — inilah mengapa data seolah-olah "tidak ada" padahal tabel sudah terisi seed data.

**Solusi Sementara (debug only):**
```sql
-- HANYA untuk testing lokal, JANGAN dipakai di production
CREATE POLICY "temp_debug_read" ON schedules 
  FOR SELECT USING (true);
```

**Solusi Permanen:**  
Perbaiki BUG-01 dan BUG-02 terlebih dahulu. RLS sudah dikonfigurasi dengan benar — masalahnya ada pada auth yang tidak berjalan.

---

### BUG-04 — `scheduleProvider` Tidak Mempertahankan Data Saat Tab Berganti

**File:** `lib/features/schedule/presentation/providers/schedule_provider.dart`  
**Dampak:** Data jadwal hilang dan di-fetch ulang setiap kali user berpindah tab

**Deskripsi:**  
Provider yang di-generate Riverpod 3.0 menggunakan `isAutoDispose: true` secara default. Ini berarti setiap kali `ScheduleScreen` di-unmount (user pindah tab), `scheduleProvider` di-dispose dan semua datanya dibuang. Ketika user kembali ke tab jadwal, provider harus fetch ulang dari Supabase. Hal yang sama berlaku untuk `checklistProvider` dan `notesProvider`.

**Kode Bermasalah:**
```dart
// lib/features/schedule/presentation/providers/schedule_provider.dart
@riverpod
class Schedule extends _$Schedule {
  @override
  FutureOr<List<ScheduleItem>> build() async {
    // Tidak ada ref.keepAlive() — provider di-dispose saat layar berganti
    return ref.watch(scheduleRepositoryProvider).getSchedules();
  }
}
```

**Perbaikan:**
```dart
@riverpod
class Schedule extends _$Schedule {
  @override
  FutureOr<List<ScheduleItem>> build() async {
    ref.keepAlive(); // ← Tambahkan ini agar data tidak hilang saat tab berganti
    return ref.watch(scheduleRepositoryProvider).getSchedules();
  }
}
```

> Lakukan hal yang sama pada `Checklist` di `checklist_provider.dart` dan `Notes` di `notes_provider.dart`.

---

## 🟡 PERINGATAN

### WARN-01 — Verifikasi Mapping `dayOfWeek` antara Dart dan Database

**File:** `lib/features/schedule/presentation/widgets/day_view.dart`  
**Dampak:** Jadwal hari tertentu bisa tampil di hari yang salah

**Deskripsi:**  
Terdapat perbedaan konvensi penomoran hari antara Dart dan database yang perlu diverifikasi ulang:

| Hari | `DateTime.weekday` (Dart) | Setelah `-1` | Database (`day_of_week`) |
|------|--------------------------|--------------|--------------------------|
| Senin | 1 | 0 | 0 ✅ |
| Selasa | 2 | 1 | 1 ✅ |
| Rabu | 3 | 2 | 2 ✅ |
| Kamis | 4 | 3 | 3 ✅ |
| Jumat | 5 | 4 | 4 ✅ |
| Sabtu | 6 | 5 | 5 ✅ |
| Minggu | 7 | 6 | 6 ✅ |

Mapping `weekday - 1` secara teknis sudah benar. Namun kode tidak menangani edge case jika `DateTime.weekday` berperilaku berbeda di zona waktu tertentu. Tambahkan log untuk memverifikasi:

```dart
// Tambahkan sementara untuk debug:
final today = DateTime.now().weekday - 1;
debugPrint('Today weekday index (DB format): $today');
debugPrint('Expected schedules count: ${items.where((i) => i.dayOfWeek == today).length}');
```

---

### WARN-02 — API Key Gemini Hardcoded di Source Code

**File:** `lib/features/ai_insight/data/gemini_service.dart`  
**Dampak:** API key ter-expose dan bisa disalahgunakan setelah APK di-decompile

**Deskripsi:**  
API key Gemini ditanam langsung di source code sebagai string literal. Key ini sudah ter-expose dalam repositori dan bisa diekstrak dari file APK menggunakan tools decompiler standar. Ini melanggar praktik keamanan dasar pengelolaan secret.

**Kode Bermasalah:**
```dart
// lib/features/ai_insight/data/gemini_service.dart
static const _apiKey = 'AIzaSyBjnDh5LRHTMhRY1AtcpJ-a2jiqqZcV17Y'; // ← JANGAN LAKUKAN INI
```

**Perbaikan:**
```dart
// Langkah 1: Hapus key dari source code
static const _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '',
);

// Langkah 2: Jalankan aplikasi dengan:
// flutter run --dart-define=GEMINI_API_KEY=your_actual_key

// Langkah 3: Untuk CI/CD, simpan di environment variable atau secrets manager
// Langkah 4: Revoke key lama di Google AI Studio dan buat key baru
```

---

### WARN-03 — UI Berkedip Saat Toggle Checklist (Pola `AsyncLoading` yang Salah)

**File:** `lib/features/checklist/presentation/providers/checklist_provider.dart`  
**Dampak:** Seluruh daftar tugas menghilang sebentar setiap kali user mencentang satu item

**Deskripsi:**  
Setiap kali user mencentang atau membatalkan centang sebuah item, provider langsung di-set ke `AsyncLoading()`. Ini menyebabkan UI menampilkan loading spinner di seluruh area checklist, lalu semua item muncul kembali setelah fetch selesai. Pola yang sama juga digunakan di `notesProvider` dan `scheduleProvider`.

**Kode Bermasalah:**
```dart
Future<void> toggleItem(ChecklistItem item) async {
  final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
  state = const AsyncLoading(); // ← Ini menghapus semua item dari layar
  state = await AsyncValue.guard(() async {
    await ref.read(checklistRepositoryProvider).updateChecklist(updatedItem);
    return ref.read(checklistRepositoryProvider).getChecklists();
  });
}
```

**Perbaikan (Optimistic Update):**
```dart
Future<void> toggleItem(ChecklistItem item) async {
  final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
  final previousItems = state.value ?? [];

  // Update UI langsung tanpa loading spinner
  state = AsyncData(
    previousItems.map((i) => i.id == item.id ? updatedItem : i).toList(),
  );

  // Sinkronisasi ke Supabase di background
  try {
    await ref.read(checklistRepositoryProvider).updateChecklist(updatedItem);
  } catch (e) {
    // Rollback jika gagal
    state = AsyncData(previousItems);
  }
}
```

---

## 🔵 MINOR

### MINOR-01 — Tanggal dan Sapaan di `GreetingHeader` Hardcoded

**File:** `lib/features/today/presentation/widgets/greeting_header.dart`  
**Dampak:** Tanggal tidak pernah berubah, sapaan tidak sesuai waktu, nama tidak dari auth

**Deskripsi:**  
Teks `'Selamat Pagi, Nailul'` dan `'RABU, 23 APRIL 2026'` ditulis sebagai string statis. Seharusnya keduanya bersifat dinamis.

**Perbaikan:**
```dart
// Ubah GreetingHeader menjadi ConsumerWidget
class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hour = DateTime.now().hour;
    final greeting = hour < 11 ? 'Pagi' : hour < 15 ? 'Siang' : 'Malam';
    final name = ref.watch(currentUserProvider)
        ?.userMetadata?['full_name']
        ?.toString()
        .split(' ')
        .first ?? 'Pengguna';
    final date = DateFormat('EEEE, d MMMM yyyy', 'id_ID')
        .format(DateTime.now())
        .toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selamat $greeting, $name', ...),
        Text(date, ...),
      ],
    );
  }
}
```

---

### MINOR-02 — Perbandingan Tipe Jadwal Salah: `'Kampus'` vs `'campus'`

**File:** `lib/features/schedule/presentation/widgets/day_view.dart` (baris `_buildScheduleCard`)  
**Dampak:** Semua kartu jadwal kampus menggunakan warna yang salah (violet, bukan lavender)

**Deskripsi:**  
Warna aksen kartu jadwal ditentukan oleh perbandingan `item.type == 'Kampus'`. Namun di database schema dan seed data, nilai yang disimpan adalah `'campus'` (huruf kecil, bahasa Inggris). Perbandingan ini selalu bernilai `false`, sehingga semua jadwal menggunakan warna `accentViolet` alih-alih `accentLavender` untuk jadwal kampus.

**Kode Bermasalah:**
```dart
// lib/features/schedule/presentation/widgets/day_view.dart
final isKampus = item.type == 'Kampus'; // ← SALAH: nilai DB adalah 'campus'
final accentColor = isKampus
    ? NexusColors.accentLavender  // tidak pernah tercapai
    : NexusColors.accentViolet;   // selalu digunakan
```

**Perbaikan:**
```dart
final isKampus = item.type == 'campus'; // ← Sesuaikan dengan nilai di DB

// Atau lebih robust, gunakan switch:
final accentColor = switch (item.type) {
  'campus' => NexusColors.accentLavender,
  'mahad'  => NexusColors.accentViolet,
  _        => NexusColors.textMuted,
};
```

---

## 📋 Checklist Perbaikan (Urutan Prioritas)

Ikuti urutan berikut untuk perbaikan yang efisien:

- [ ] **[BUG-02]** Ganti `anonKey` di `main.dart` dengan JWT key yang valid dari Supabase Dashboard
- [ ] **[BUG-01]** Refactor `router.dart` agar membaca auth state dari Riverpod/Supabase
- [ ] **[WARN-02]** Revoke Gemini API key lama, buat key baru, pindahkan ke `--dart-define`
- [ ] **[BUG-03]** Verifikasi RLS berfungsi setelah BUG-01 dan BUG-02 diperbaiki
- [ ] **[BUG-04]** Tambahkan `ref.keepAlive()` pada ketiga provider utama
- [ ] **[WARN-03]** Implementasikan optimistic update pada `toggleItem` di `checklistProvider`
- [ ] **[MINOR-02]** Perbaiki perbandingan `item.type == 'Kampus'` → `'campus'`
- [ ] **[MINOR-01]** Jadikan `GreetingHeader` dinamis menggunakan `DateTime.now()` dan auth provider
- [ ] **[WARN-01]** Tambahkan debug log untuk verifikasi mapping `dayOfWeek`

---

## 🗂️ File yang Perlu Dimodifikasi

| File | Bug Terkait | Jenis Perubahan |
|------|-------------|-----------------|
| `lib/main.dart` | BUG-02 | Ganti `anonKey` dengan JWT yang valid |
| `lib/app/router.dart` | BUG-01 | Refactor ke `Provider<GoRouter>` dengan Riverpod |
| `lib/features/ai_insight/data/gemini_service.dart` | WARN-02 | Pindahkan key ke `String.fromEnvironment` |
| `lib/features/schedule/presentation/providers/schedule_provider.dart` | BUG-04 | Tambahkan `ref.keepAlive()` |
| `lib/features/checklist/presentation/providers/checklist_provider.dart` | BUG-04, WARN-03 | `keepAlive` + optimistic update |
| `lib/features/notes/presentation/providers/notes_provider.dart` | BUG-04 | Tambahkan `ref.keepAlive()` |
| `lib/features/schedule/presentation/widgets/day_view.dart` | MINOR-02, WARN-01 | Fix type comparison + debug log |
| `lib/features/today/presentation/widgets/greeting_header.dart` | MINOR-01 | Jadikan dinamis dengan `ConsumerWidget` |

---

*Laporan ini dibuat berdasarkan analisis statis source code. Pengujian runtime diperlukan untuk konfirmasi akhir setelah perbaikan diterapkan.*