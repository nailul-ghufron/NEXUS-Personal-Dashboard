# 🌌 Nexus — PRD for AI Coding Agents
### *Antigravity Edition · Flutter + Firebase*

> **Dokumen ini adalah Product Requirements Document (PRD) yang dirancang khusus untuk AI Coding Agents.**
> Setiap seksi ditulis dengan konteks, keputusan, dan spesifikasi yang cukup untuk memungkinkan agen mengeksekusi tanpa ambiguitas.

---

## 📋 Metadata Proyek

| Field | Value |
|---|---|
| **Nama Proyek** | Nexus — Personal Dashboard |
| **Edisi** | Antigravity (Flutter + Supabase) |
| **Platform Target** | Android & iOS (Mobile-First) |
| **Stack Utama** | Flutter 3.x + Supabase |
| **Versi PRD** | 1.0.0 |
| **Tanggal** | April 2026 |
| **Author** | Muhammad Nailul Ghufron Majid |
| **NIM** | 240605110160 |
| **Jurusan** | Teknik Informatika |
| **Timezone** | WIB (Kota Malang, Jawa Timur) |

---

## 🎯 Visi Produk

**Nexus** adalah aplikasi mobile personal dashboard berbasis **Flutter** dengan backend **Supabase**, dirancang khusus untuk mahasiswa. Aplikasi ini fokus pada tiga pilar utama:

1. **Hari Ini (Today)** — Ringkasan fokus harian yang actionable
2. **Jadwal** — Manajemen jadwal kuliah & ma'had
3. **Checklist & Notes** — Habit tracking dan catatan cepat

> ⚠️ **Fitur yang DIPANGKAS dari versi sebelumnya:**
> - ~~`/tasks`~~ — Task Management (Board/List/Calendar view) → **DIHAPUS**
> - ~~`/analytics`~~ — Analytics Dashboard (Activity Pulse, Wallet Widget) → **DIHAPUS**
> - ~~`/finance`~~ — Keuangan (transaksi, statistik) → **DIHAPUS**

---

## 🏗️ Arsitektur Aplikasi

### Struktur Direktori Flutter

```
lib/
├── main.dart                        # Entry point
├── .env                             # Environment variables (Supabase Keys)
├── app/
│   ├── app.dart                     # MaterialApp / root widget
│   └── router.dart                  # GoRouter route definitions
├── core/
│   ├── constants/
│   │   ├── colors.dart              # NexusColors design tokens
│   │   ├── typography.dart          # TextStyles
│   │   └── spacing.dart             # Spacing constants
│   ├── theme/
│   │   └── nexus_theme.dart         # ThemeData (dark premium)
│   ├── utils/
│   │   ├── date_utils.dart          # WIB date helpers
│   │   └── wib_clock.dart           # Timezone-aware clock
│   └── widgets/
│       ├── glass_card.dart          # Glassmorphism Card primitive
│       ├── glass_button.dart        # Glassmorphism Button
│       ├── glass_input.dart         # Glassmorphism TextInput
│       ├── nexus_modal.dart         # Bottom sheet / modal reusable
│       └── skeleton_loader.dart     # Shimmer skeleton loading
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── presentation/
│   │   │   ├── login_screen.dart
│   │   │   └── widgets/
│   │   │       └── mesh_gradient_bg.dart
│   │   └── auth_provider.dart       # Riverpod provider
│   ├── today/
│   │   ├── data/
│   │   │   └── today_repository.dart
│   │   ├── presentation/
│   │   │   ├── today_screen.dart
│   │   │   └── widgets/
│   │   │       ├── greeting_header.dart
│   │   │       ├── next_class_card.dart
│   │   │       └── today_habits_card.dart
│   │   └── today_provider.dart
│   ├── schedule/
│   │   ├── data/
│   │   │   └── schedule_repository.dart
│   │   ├── models/
│   │   │   └── schedule_model.dart
│   │   ├── presentation/
│   │   │   ├── schedule_screen.dart
│   │   │   └── widgets/
│   │   │       ├── day_view.dart
│   │   │       ├── table_view.dart
│   │   │       └── calendar_view.dart
│   │   └── schedule_provider.dart
│   ├── checklist/
│   │   ├── data/
│   │   │   └── checklist_repository.dart
│   │   ├── models/
│   │   │   ├── checklist_item_model.dart
│   │   │   └── checklist_log_model.dart
│   │   ├── presentation/
│   │   │   ├── checklist_screen.dart
│   │   │   └── widgets/
│   │   │       ├── checklist_tile.dart
│   │   │       └── progress_ring.dart
│   │   └── checklist_provider.dart
│   ├── notes/
│   │   ├── data/
│   │   │   └── notes_repository.dart
│   │   ├── models/
│   │   │   └── note_model.dart
│   │   ├── presentation/
│   │   │   ├── notes_screen.dart
│   │   │   └── widgets/
│   │   │       └── note_card.dart
│   │   └── notes_provider.dart
│   ├── notifications/
│   │   ├── data/
│   │   │   └── notification_repository.dart
│   │   ├── models/
│   │   │   └── notification_model.dart
│   │   ├── presentation/
│   │   │   └── notification_panel.dart
│   │   └── notification_provider.dart
│   └── pomodoro/
│       ├── presentation/
│       │   └── pomodoro_widget.dart  # Floating timer di nav bar
│       └── pomodoro_provider.dart
└── shared/
    ├── navigation/
    │   ├── bottom_nav.dart           # Floating nav bar
    │   └── fab_menu.dart             # Expandable FAB
    └── quick_entry/
        ├── quick_entry_modal.dart
        ├── add_activity_form.dart
        └── add_schedule_form.dart
```

---

## 🔥 Tech Stack

| Layer | Teknologi | Versi |
|---|---|---|
| **Framework** | Flutter | ≥ 3.19 |
| **Bahasa** | Dart | ≥ 3.3 |
| **Auth** | Firebase Authentication | Email/Password + Google Sign-In |
| **Database** | Cloud Firestore | Real-time listeners |
| **Storage** | Firebase Storage | Avatar upload |
| **Push Notif** | Firebase Cloud Messaging (FCM) | Background + Foreground |
| **State Management** | Riverpod | ≥ 2.5 (code generation) |
| **Routing** | GoRouter | ≥ 14.x |
| **Local Storage** | Hive | Caching offline |
| **Animasi** | flutter_animate | Fade, scale, slide |
| **Glassmorphism** | Custom painter + BackdropFilter | — |
| **Timezone** | timezone + flutter_timezone | WIB handling |
| **Date** | intl | Format tanggal |
| **Validasi** | reactive_forms | Form management |
| **Icons** | lucide_icons_flutter | Konsisten dengan Nexus web |

### pubspec.yaml — Dependencies Utama

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Supabase
  supabase_flutter: ^2.x

  # State & Routing
  flutter_riverpod: ^2.5
  riverpod_annotation: ^2.3
  go_router: ^14.x

  # UI & Animasi
  flutter_animate: ^4.5
  google_fonts: ^6.x

  # Utilities
  intl: ^0.19
  timezone: ^0.9
  flutter_timezone: ^1.x
  hive_flutter: ^1.x
  reactive_forms: ^17.x
  image_picker: ^1.x
  cached_network_image: ^3.x
  uuid: ^4.x

dev_dependencies:
  riverpod_generator: ^2.4
  build_runner: ^2.4
  flutter_test:
    sdk: flutter
```

---

## 🔐 Supabase Schema (PostgreSQL)

> Setiap table dilindungi dengan **Row Level Security (RLS)** — user hanya dapat mengakses baris miliknya sendiri (`auth.uid() = user_id`).

### Collection: `users`
```
users/{userId}
  ├── displayName: String
  ├── nim: String
  ├── jurusan: String
  ├── avatarUrl: String?
  ├── createdAt: Timestamp
  └── welcomeShown: Boolean
```

### Collection: `schedules`
```
schedules/{scheduleId}
  ├── userId: String        (indexed)
  ├── nama: String
  ├── hari: String          (Senin–Ahad)
  ├── jamMulai: String      (HH:mm)
  ├── jamSelesai: String    (HH:mm)
  ├── ruangan: String?
  ├── dosen: String?
  ├── tipe: String          (kampus | mahad)
  └── createdAt: Timestamp
```

### Collection: `checklist_items`
```
checklist_items/{itemId}
  ├── userId: String        (indexed)
  ├── label: String
  ├── kategori: String      (harian | mingguan | custom)
  ├── urutan: Number
  └── createdAt: Timestamp
```

### Collection: `checklist_logs`
```
checklist_logs/{logId}
  ├── userId: String        (indexed)
  ├── itemId: String        (indexed)
  ├── tanggal: String       (YYYY-MM-DD)
  └── selesai: Boolean
```

### Collection: `activity_logs`
```
activity_logs/{logId}
  ├── userId: String        (indexed)
  ├── tanggal: String       (YYYY-MM-DD)
  └── score: Number
```

### Collection: `notes`
```
notes/{noteId}
  ├── userId: String        (indexed)
  ├── title: String?
  ├── content: String
  ├── color: String         (hex color)
  ├── createdAt: Timestamp
  └── updatedAt: Timestamp
```

### Collection: `notifications`
```
notifications/{notifId}
  ├── userId: String        (indexed)
  ├── title: String
  ├── body: String
  ├── type: String          (schedule | checklist | system)
  ├── deepLink: String?
  ├── isRead: Boolean
  └── createdAt: Timestamp
```

### Firebase Security Rules (Contoh)
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{collection}/{docId} {
      allow read, write: if request.auth != null
        && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.userId;
    }
    match /users/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId;
    }
  }
}
```

---

## 📱 Fitur & Spesifikasi

### 🔐 1. The Gate — Autentikasi

**Screen:** `LoginScreen`

**Behavior:**
- Animasi mesh gradient background (dark, multi-color subtle)
- Input email & password dengan style glassmorphism
- Tombol **Login** → Supabase Auth `signInWithPassword`
- Tombol **Google** → `signInWithOAuth(Provider.google)`
- Error handling: tampilkan snackbar bila credential salah
- Redirect ke `/today` setelah login berhasil
- `GoRouter` redirect guard: jika sudah login → skip ke `/today`

**State:** `AuthProvider` (Riverpod) — watch `supabase.auth.onAuthStateChange`

---

### 🏠 2. Hari Ini (Today)

**Route:** `/today`  
**Screen:** `TodayScreen`

**Komponen & Behavior:**

| Widget | Deskripsi |
|---|---|
| `GreetingHeader` | Salam dinamis berdasarkan jam WIB (Pagi/Siang/Sore/Malam) + nama user |
| `NextClassCard` | Jadwal kuliah/ma'had berikutnya hari ini dari Firestore `schedules` |
| `TodayHabitsCard` | Progress checklist hari ini (jumlah selesai / total) |

**Data fetching:**
- `NextClassCard` query ke `schedules` where `hari == hariIni`, sort by `jamMulai`, ambil entry pertama yang `jamMulai > sekarang`
- `TodayHabitsCard` query ke `checklist_logs` where `tanggal == hari ini`

**Auto-refresh:** Gunakan `StreamProvider` Riverpod untuk listen perubahan real-time Firestore.

---

### 📅 3. Jadwal

**Route:** `/schedule`  
**Screen:** `ScheduleScreen`

**Sub-views (Tab):**
1. **Day View** — Kartu jadwal hari ini + selector hari dalam minggu
2. **Table View** — Grid mingguan (Senin–Jumat + Sabtu/Ahad opsional)
3. **Calendar View** — Kalender bulanan dengan dot indicator per hari ada jadwal

**Filter:** Toggle `Kampus` / `Ma'had`

**CRUD:**
- FAB → `AddScheduleForm` (bottom sheet)
- Long-press item → opsi Edit / Hapus

**Model:** `ScheduleModel` dengan field: `id`, `nama`, `hari`, `jamMulai`, `jamSelesai`, `ruangan`, `dosen`, `tipe`

---

### 📋 4. Checklist

**Route:** `/checklist`  
**Screen:** `ChecklistScreen`

**Behavior:**
- **Navigasi tanggal** — Swipe atau tap tombol `←` / `→` untuk navigasi ke hari sebelum/sesudah, default ke hari ini
- **Progress Ring** — Circular indicator menampilkan `X / Y selesai` (animated)
- **Kategori Tab** — `Harian` | `Mingguan` | `Custom`
- **ChecklistTile** — Toggle selesai/belum, animasi check mark
- **Auto-update Activity Score** — Setelah toggle, update `activity_logs` untuk hari tersebut

**CRUD:**
- Tambah item → modal form (label, kategori)
- Swipe-to-delete item checklist

**Real-time:** `StreamProvider` untuk `checklist_logs` hari aktif.

---

### 📝 5. Notes

**Route:** `/notes`  
**Screen:** `NotesScreen`

**Behavior:**
- Grid / list tampilan note card berwarna (`NoteCard`)
- Tap note → buka `NoteDetailScreen` / bottom sheet editor
- **Auto-save** — Debounce 1 detik saat user mengetik, langsung update Firestore
- **Optimistic UI** — Update lokal state terlebih dahulu sebelum Firestore konfirmasi
- Warna note dapat dipilih (6 warna preset)

**CRUD:** Create, Read, Update, Delete lengkap.

---

### 🔔 6. Notification Center

**Panel:** `NotificationPanel` (bottom sheet atau overlay)

**Behavior:**
- Diakses dari ikon lonceng di app bar
- **Badge** — Jumlah notifikasi belum dibaca (`isRead == false`)
- **List notifikasi** — Sorted by `createdAt` desc
- Tap notif → navigasi ke `deepLink` (GoRouter)
- **Mark as read** — Tap satuan atau "Tandai Semua Dibaca"
- **Real-time** via Firestore `StreamProvider`

**FCM Integration:**
- Handle foreground notif → tampilkan in-app banner (flutter_local_notifications)
- Handle background/terminated → tap buka app + navigate ke deepLink via GoRouter

---

### ⏱️ 7. Pomodoro Timer

**Widget:** `PomodoroWidget` (embedded di bottom nav bar)

**Behavior:**
- Timer 25 menit default (dapat dikonfigurasi 5/10/15/25/50 menit)
- State global via `PomodoroProvider` (Riverpod) — timer tetap berjalan saat pindah screen
- Tampil sebagai floating chip kecil di atas bottom nav saat aktif
- Tap chip → expand panel kecil (pause/resume/stop/reset)
- Saat selesai → vibrate + local notification "Sesi fokus selesai!"

---

### 🧭 8. The Anchor — Navigasi

**Widget:** `BottomNavBar` (floating, pill-shape, glassmorphism)

**4 Menu Utama (setelah pemangkasan):**

| Ikon | Label | Route |
|---|---|---|
| 🏠 | Hari Ini | `/today` |
| 📅 | Jadwal | `/schedule` |
| 📋 | Checklist | `/checklist` |
| 📝 | Notes | `/notes` |

**FAB (Floating Action Button):**
- Tombol `+` di tengah nav bar
- Tap → expandable menu dengan 2 opsi:
  - **Catatan** — Tambah note cepat
  - **Jadwal** — Input jadwal baru
- Animasi: spring animation saat expand/collapse

**Perilaku Nav Bar:**
- **Scroll Auto-hide** — Nav bar & FAB tersembunyi saat scroll ke bawah, muncul kembali saat scroll ke atas
- **Idle Transparency** — Setelah 3 detik idle, opacity turun ke 60%
- **Haptic Feedback** — `HapticFeedback.lightImpact()` saat tap menu

---

### ⚡ 9. Quick Entry Modal

**Widget:** `QuickEntryModal` (modal bottom sheet)

**Forms:**
1. `AddActivityForm` — Tambah item checklist (label, kategori)
2. `AddScheduleForm` — Tambah jadwal (nama, hari, jam, ruangan, tipe)

---

## 🎨 Sistem Desain

### Design Tokens

```dart
// lib/core/constants/colors.dart

class NexusColors {
  // Base
  static const background = Color(0xFF030712);
  static const surface    = Color(0xFF0D1117);
  static const surfaceGlass = Color(0x0DFFFFFF);  // white/5

  // Accent
  static const accentBlue = Color(0xFF2563EB);
  static const accentCyan = Color(0xFF22D3EE);
  static const accentGrad = LinearGradient(
    colors: [accentBlue, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted     = Color(0xFF475569);

  // Semantic
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger  = Color(0xFFEF4444);

  // Glass
  static const glassBorder    = Color(0x1AFFFFFF);  // white/10
  static const glassBlur      = 16.0;               // blur radius
}
```

### Glass Card Primitive

```dart
// lib/core/widgets/glass_card.dart

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: NexusColors.glassBlur,
          sigmaY: NexusColors.glassBlur,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: NexusColors.surfaceGlass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: NexusColors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### ThemeData

```dart
// lib/core/theme/nexus_theme.dart

ThemeData nexusTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: NexusColors.background,
  colorScheme: const ColorScheme.dark(
    primary: NexusColors.accentCyan,
    secondary: NexusColors.accentBlue,
    surface: NexusColors.surface,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: NexusColors.textPrimary,
  ),
  fontFamily: 'Inter',           // via google_fonts
  useMaterial3: true,
);
```

| Properti | Nilai |
|---|---|
| **Tema** | Dark Mode Premium `#030712` |
| **Aksen** | Blue → Cyan Gradient |
| **Glass** | `BackdropFilter blur(16) + white/5 bg + white/10 border` |
| **Font** | Inter (Google Fonts) |
| **Border Radius** | 24px default (extra large) |
| **Animasi** | `flutter_animate` — fade, slide-up, scale, stagger |
| **FAB Glow** | Cyan pulse container shadow |

---

## 🗺️ Routing (GoRouter)

```dart
// lib/app/router.dart

final router = GoRouter(
  initialLocation: '/today',
  redirect: (context, state) {
    final auth = FirebaseAuth.instance.currentUser;
    final isLogin = state.matchedLocation == '/login';
    if (auth == null && !isLogin) return '/login';
    if (auth != null && isLogin) return '/today';
    return null;
  },
  routes: [
    GoRoute(path: '/login',     builder: (_, __) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/today',     builder: (_, __) => const TodayScreen()),
        GoRoute(path: '/schedule',  builder: (_, __) => const ScheduleScreen()),
        GoRoute(path: '/checklist', builder: (_, __) => const ChecklistScreen()),
        GoRoute(path: '/notes',     builder: (_, __) => const NotesScreen()),
      ],
    ),
  ],
);
```

`MainShell` adalah widget yang wrap content dengan `BottomNavBar`.

---

## 🔄 State Management Pattern (Riverpod)

Gunakan **code generation** Riverpod (`@riverpod` annotation).

### Contoh: Schedule Provider

```dart
// features/schedule/schedule_provider.dart

@riverpod
Stream<List<ScheduleModel>> schedules(SchedulesRef ref) {
  final uid = ref.watch(currentUserProvider)!.uid;
  return FirebaseFirestore.instance
    .collection('schedules')
    .where('userId', isEqualTo: uid)
    .snapshots()
    .map((snap) => snap.docs
      .map((d) => ScheduleModel.fromFirestore(d))
      .toList());
}
```

### Contoh: Notes Provider dengan Optimistic Update

```dart
@riverpod
class NotesNotifier extends _$NotesNotifier {
  @override
  Stream<List<NoteModel>> build() {
    final uid = ref.watch(currentUserProvider)!.uid;
    return _repo.watchNotes(uid);
  }

  Future<void> updateNote(String id, String content) async {
    // Optimistic: update local state dulu
    state = AsyncData(state.value!.map((n) =>
      n.id == id ? n.copyWith(content: content) : n).toList());
    // Kemudian sync ke Firestore
    await _repo.updateNote(id, content);
  }
}
```

---

## ⚡ Fitur Teknis Kritis

### Date Guard (Midnight Refresh)
- Jalankan `Timer.periodic` setiap menit
- Deteksi jika tanggal lokal berubah → invalidate semua `StreamProvider` yang bergantung pada tanggal hari ini
- Implementasi di `main.dart` atau root `ConsumerStatefulWidget`

### WIB Timezone Handling
```dart
// lib/core/utils/wib_clock.dart
import 'package:timezone/timezone.dart' as tz;

DateTime nowWIB() {
  final wib = tz.getLocation('Asia/Jakarta');
  return tz.TZDateTime.now(wib);
}

String hariIni() {
  const days = ['Ahad','Senin','Selasa','Rabu','Kamis','Jumat','Sabtu'];
  return days[nowWIB().weekday % 7];
}
```

### Offline Support (Hive Cache)
- Cache data `schedules` dan `checklist_items` ke Hive saat pertama kali fetch
- Tampilkan cached data saat tidak ada koneksi
- Sinkronisasi ulang saat koneksi kembali

### Haptic Feedback
```dart
// Di setiap interaksi nav bar / FAB
HapticFeedback.lightImpact();
```

### Welcome Popup
- Cek field `welcomeShown` di Firestore `users/{uid}`
- Jika `false` → tampilkan `WelcomeDialog` saat pertama kali login
- Set `welcomeShown = true` setelah dismissed

---

## 🧪 Testing Strategy

| Level | Tool | Target |
|---|---|---|
| **Unit** | `flutter_test` | Repository, Provider logic, Utils |
| **Widget** | `flutter_test` | GlassCard, ChecklistTile, NoteCard |
| **Integration** | `integration_test` | Auth flow, Checklist toggle, Schedule CRUD |
| **Mock** | `mocktail` | Firebase mocking untuk unit test |

---

## 🚀 Setup & Onboarding untuk AI Agent

### Prasyarat
- Flutter SDK ≥ 3.19
- Dart ≥ 3.3
- Firebase project dengan services aktif: Authentication, Firestore, Storage, FCM
- `flutterfire configure` sudah dijalankan → `firebase_options.dart` ter-generate

### Langkah Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Riverpod code
dart run build_runner build --delete-conflicting-outputs

# 3. Setup Firebase (jika belum)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Run aplikasi
flutter run
```

### Environment
Tidak ada `.env` file — semua config Firebase ada di `firebase_options.dart` (auto-generated, gitignored bila perlu).

---

## 📜 Changelog

### v1.0.0 — April 2026 (Antigravity Edition)
- 🔥 **Migrasi stack**: Firebase → Supabase
- 🗑️ **Dipangkas**: `/tasks`, `/analytics`, `/finance`
- ✅ **Dipertahankan**: Today, Schedule, Checklist, Notes, Notifications, Pomodoro
- 🎯 **Fokus**: Mobile-native experience dengan Flutter
- 🔄 **State**: Riverpod dengan code generation
- 🗄️ **Database**: Firestore dengan Security Rules
- 📱 **Platform**: Android & iOS

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah [MIT License](./LICENSE.md).

---

*PRD ini dibuat untuk AI Coding Agents. Setiap keputusan desain, arsitektur, dan spesifikasi teknis telah ditulis dengan konteks yang cukup untuk dieksekusi tanpa klarifikasi tambahan.*
