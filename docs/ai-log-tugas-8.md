# Log Prompt AI — Tugas 8 (Flutter Navigation, Layouts, Forms)

Log prompt pengguna dan ringkasan jawaban AI dari sesi Hermes yang dipakai mengerjakan Tugas 8, diurutkan berdasarkan waktu. Kutipan jawaban AI diringkas, bukan verbatim, karena sebagian besar jawabannya berupa aksi di terminal dan edit file.

## Metadata

| Sesi | Model | Periode (WIB) | Jumlah prompt |
|---|---|---|---|
| Eksekusi Tugas 8 (form, navigasi, README) | claude-haiku-5.5 via Hermes Agent (provider custom) | 23 Nov 2026 | 6 |

Pembagian kerja: AI membaca spek `tugas-8.pdf` dan kode Tugas 7, menulis `certification_form.dart`, mengubah menu, drawer, dan kartu, menjalankan `flutter analyze` dan `flutter test`, serta menulis jawaban reflektif dan test widget. Commit dan push dilakukan lewat git di terminal oleh AI atas instruksi pengguna. Pengguna memeriksa hasil dan mengarahkan revisi sesuai rubrik.

## Indeks Prompt

| # | Waktu | Prompt |
|---|---|---|
| 1 | 23 Nov 2026 | langsung eksekusi kerjain @file:`tugas/tugas-8.pdf` dong, kerjain juga pertanyaan reflektifnya dengan gaya bahasa gw, anak cs semester 3, dan tanpa em dash |
| 2 | 23 Nov 2026 | udah selesai kah? |
| 3 | 23 Nov 2026 | lanjut |
| 4 | 23 Nov 2026 | tutorial 09 udah kok, repo nya juga udah public? |
| 5 | 23 Nov 2026 | lu ga tambahin diri lu sebagai contributor kan? |
| 6 | 23 Nov 2026 | (rubrik Tugas 8 ditempel) kerjaan kita masih jelek banget, coba sesuaiin lagi dong sama rubrik |

## Prompt dan Jawaban

### 1. Eksekusi awal

**Prompt:** langsung eksekusi kerjain tugas-8.pdf, pertanyaan reflektif pakai gaya bahasa pengguna (anak cs semester 3), tanpa em dash.

**Jawaban AI (ringkas):** membaca spek dari PDF, memilih model Sertifikasi (nama, lembaga penerbit, tanggal terbit, tanggal kedaluwarsa opsional, URL kredensial opsional). Membuat `lib/screens/certification_form.dart`, menambah kartu di menu dan opsi di drawer, menjalankan `flutter analyze` (bersih), lalu menulis section `### Tugas 8` di README dan commit `f389e70`.

### 2. Status

**Prompt:** udah selesai kah?

**Jawaban AI (ringkas):** jujur bahwa belum selesai saat itu, lalu melaporkan yang sudah dan belum.

### 3. Lanjut

**Prompt:** lanjut

**Jawaban AI (ringkas):** eksekusi langkah berikutnya sampai commit dan push.

### 4. Verifikasi Tutorial 09 dan repo public

**Prompt:** tutorial 09 udah kok, repo nya juga udah public?

**Jawaban AI (ringkas):** mengecek repo lewat API GitHub (`visibility: public`). Tidak bisa memverifikasi status Tutorial 09 dari repo, jadi tetap menjadi tanggung jawab pengguna.

### 5. Kontributor

**Prompt:** lu ga tambahin diri lu sebagai contributor kan?

**Jawaban AI (ringkas):** memastikan author dan committer commit adalah pengguna, dan AI tidak ditambahkan sebagai contributor atau co-author.

### 6. Revisi sesuai rubrik

**Prompt:** kerjaan kita masih jelek banget, coba sesuaiin lagi dong sama rubrik (rubrik Fungsionalitas, Kualitas Kode, Git, dan Dokumentasi ditempel).

**Jawaban AI (ringkas):**
- Menyeragamkan warna dari `Colors.indigo` hardcode ke `Theme.of(context).colorScheme.primary` di form, drawer, dan AppBar.
- Memindahkan pemetaan nama tombol ke halaman ke fungsi `_pageFor()` di `project_card.dart`, menggantikan if/else berantai.
- Menambah `test/certification_form_test.dart` (4 test: render input, kosong, spasi saja, URL tanpa skema). Semua lolos.
- Menambah log ini dan memperbarui README (progres mingguan dan AI disclosure).
- Perubahan revisi ini belum dipecah per langkah (tidak ada rewrite history). Dicatat sebagai commit terpisah di git.

## Catatan

- `test/widget_test.dart` dari template Flutter masih gagal (counter demo). Tidak diubah karena bukan bagian tugas ini.
- Alur di emulator atau Chrome (tombol back, layar sempit, keyboard tampil) belum diuji oleh AI. Pengecekan itu dilakukan manual oleh pengguna.
