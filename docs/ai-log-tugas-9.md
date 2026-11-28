# Log Prompt AI - Tugas 9 (Flutter Backend Integration, Authentication, CI/CD)

Log prompt pengguna dan ringkasan jawaban AI dari sesi Hermes yang dipakai mengerjakan Tugas 9, diurutkan berdasarkan waktu. Kutipan jawaban AI diringkas, bukan verbatim, karena sebagian besar jawabannya adalah panduan langkah dan review dari kode yang sudah ada di repo.

## Metadata

| Sesi | Model | Periode (WIB) | Jumlah prompt |
|---|---|---|---|
| Bantuan Tugas 9 (langkah, review rubrik, log ini) | Muse Ember via Hermes Agent (provider OpenRouter) | 28 Nov 2026 | 4 |

Pembagian kerja: AI membaca `tugas/tugas-9.pdf`, mengaudit kondisi repo `myportofolio_mobile` dan backend `myportofolio`, memberi langkah pengerjaan seperti di tutorial, dan mereview hasil berdasarkan rubrik. Implementasi Tugas 9 dikerjakan pengguna sendiri di repo (branch `feat/experience-integration`, commit `94f7966` sampai `33e8802`). Commit dan push file log ini: commit oleh AI, push oleh pengguna di terminalnya sendiri sesuai aturan kerja PBP.

## Indeks Prompt

| # | Waktu | Prompt |
|---|---|---|
| 1 | 28 Nov 2026 | Bantu gw kerjain @file:`tugas/tugas-9.pdf` dong. Kayak biasa kasih gw langkah-langkah kayak di tutorial biar gw kerjain sendiri |
| 2 | 28 Nov 2026 | coba diriview dong berdasarkan rubrik |
| 3 | 28 Nov 2026 | kualitas code dan git belum layak 4 kah? |
| 4 | 28 Nov 2026 | bikin ai log dari sesi ini, push biar gw aja |

## Prompt dan Jawaban

### 1. Langkah pengerjaan Tugas 9

**Prompt:** Bantu gw kerjain @file:`tugas/tugas-9.pdf` dong. Kayak biasa kasih gw langkah-langkah kayak di tutorial biar gw kerjain sendiri

**Jawaban AI (ringkas):** membaca spek Tugas 9 dari `tugas/tugas-9.pdf` (integrasi backend DRF, autentikasi token, CI/CD) lalu mengaudit kondisi repo: model, ApiClient, list/detail screen, form, dan workflow CI sudah ada untuk section Project, tetapi spek menolak section Project dan meminta setidaknya satu bagian selain Project. Dari backend `myportofolio`, yang tersedia di Assignment 6 adalah `experiences/`, sehingga yang dipilih adalah Experience. Langkah yang diberikan: buat `lib/models/experience.dart` dengan `@JsonSerializable(fieldRename: FieldRename.snake)` cocok dengan `ExperienceSerializer`, jalankan `dart run build_runner build --delete- conflicting-outputs`, tambah `getExperiences` dan `createExperience` ke `ApiClient`, buat layar daftar dan detail dengan `FutureBuilder` + `RefreshIndicator`, buat form dengan `ensureLoggedIn` dan penanganan `ApiException` 401, hubungkan kartu menu dan drawer, lalu uji end-to-end termasuk simulasi 401 dengan menghapus token lewat Django Admin.

### 2. Review berdasarkan rubrik

**Prompt:** coba diriview dong berdasarkan rubrik

**Jawaban AI (ringkas):** menjalankan `flutter analyze` (No issues found), `flutter test` (14 passed), `dart format` (0 changed), dan pengecekan grep untuk `TODO`, em dash, dan file `*.g.dart` yang ter-track (tidak ada). Per kriteria: Fungsionalitas 3.5 dengan kandidat 4 (extra DELETE terautentikasi di detail + unit test MockClient `test/api_client_test.dart`), Kualitas Kode 3.5, Git 3.0 karena 5 commit belum di-push, Dokumentasi 3.0 karena `docs/ai-log-tugas-9.md` belum ada. Catatan jujurnya: status CI hijau + artefak `app-release-apk` dan flow end-to-end belum ada buktinya dari sesi ini.

### 3. Kelayakan nilai 4 Kualitas Kode dan Git

**Prompt:** kualitas code dan git belum layak 4 kah?

**Jawaban AI (ringkas):** Git layak 4 karena ada branch fitur `feat/experience-integration` dan riwayat Conventional Commits berbahasa Indonesia per fitur, tinggal merge `--no-ff` ke `main` dan push supaya URL commit untuk SCELE terbentuk. Kualitas Kode layak 4 karena `flutter analyze` bersih, `dart format` lolos, tidak ada `TODO`, typing kuat (satu-satunya `dynamic` ada di `fromJson`/`jsonDecode` dan langsung di-cast), dan ada unit/widget test yang bermakna (`test/api_client_test.dart` dengan MockClient), sehingga memenuhi jalur "unit/widget test" di rubrik 4 tanpa harus pindah ke `very_good_analysis` yang risikonya tidak sepadan dekat deadline.

### 4. File log ini

**Prompt:** bikin ai log dari sesi ini, push biar gw aja

**Jawaban AI (ringkas):** membuat `docs/ai-log-tugas-9.md` dari sesi ini mengikuti pola `ai-log-tugas-8.md`, lalu meng-commit-nya lokal dengan pesan `docs(ai-log): tambahkan log prompting Tugas 9` dan menyerahkan push ke pengguna di terminalnya sendiri.
