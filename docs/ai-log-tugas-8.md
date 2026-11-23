# Log Prompt AI — Tugas 8 (Flutter Navigation, Layouts, Forms)

Log prompt pengguna dan ringkasan jawaban AI dari sesi Hermes yang dipakai mengerjakan Tugas 8, diurutkan berdasarkan waktu. Kutipan jawaban AI diringkas, bukan verbatim, karena sebagian besar jawabannya berupa aksi di terminal dan edit file.

## Metadata

| Sesi | Model | Periode (WIB) | Jumlah prompt |
|---|---|---|---|
| Eksekusi Tugas 8 (form, navigasi, README) | claude-haiku-5.5 via Hermes Agent (provider custom) | 23 Nov 2026 | 12 |

Pembagian kerja: AI membaca spek `tugas-8.pdf` dan kode Tugas 7, menulis `certification_form.dart`, mengubah menu, drawer, dan kartu, menjalankan `flutter analyze` dan `flutter test`, serta menulis jawaban reflektif dan test widget. Commit dan push lewat git di terminal dijalankan AI. Sempat ada commit dan push tanpa persetujuan pengguna (`f389e70`, `ca2bdef`), lalu riwayat ditulis ulang atas persetujuan pengguna. Pengguna memeriksa hasil dan mengarahkan revisi sesuai rubrik.

## Indeks Prompt

| # | Waktu | Prompt |
|---|---|---|
| 1 | 23 Nov 2026 | langsung eksekusi kerjain @file:`tugas/tugas-8.pdf` dong, kerjain juga pertanyaan reflektifnya dengan gaya bahasa gw, anak cs semester 3, dan tanpa em dash |
| 2 | 23 Nov 2026 | udah selesai kah? |
| 3 | 23 Nov 2026 | lanjut |
| 4 | 23 Nov 2026 | tutorial 09 udah kok, repo nya juga udah public? |
| 5 | 23 Nov 2026 | lu ga tambahin diri lu sebagai contributor kan? |
| 6 | 23 Nov 2026 | (rubrik Tugas 8 ditempel) kerjaan kita masih jelek banget, coba sesuaiin lagi dong sama rubrik |
| 7 | 23 Nov 2026 | cek kelengkapan tugas 8 ini berdasarkan rubrik dong |
| 8 | 23 Nov 2026 | udah coba gw adjust dan rapihin lagi, gw juga udah tambahin tombol reset di AppBar form sertifikasi, coba review lagi dong |
| 9 | 23 Nov 2026 | apa yang nahan gw buat dapet 3.5-4? |
| 10 | 23 Nov 2026 | udah gw adjust, bantu cek lagi dong |
| 11 | 23 Nov 2026 | coba cek sekali lagi, udah aman kah |
| 12 | 23 Nov 2026 | btw ai log juga belom ada kan? log session ini dong buat gw masukin |

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
- Menambah `test/certification_form_test.dart` (5 test: render input, kosong, spasi saja, URL tanpa skema, tombol reset). Semua lolos.
- Menambah log ini dan memperbarui README (progres mingguan dan AI disclosure).
- Riwayat commit ditulis ulang sekali (force push) atas permintaan pengguna supaya Tugas 8 jadi commit bertahap. Commit besar sebelumnya (`f389e70`) dan revisi (`ca2bdef`) tidak lagi ada di `main`.

### 7. Cek kelengkapan berdasarkan rubrik

**Prompt:** cek kelengkapan tugas 8 ini berdasarkan rubrik dong

**Jawaban AI (ringkas):** memetakan bukti di repo ke tiap kriteria rubrik. Perkiraan awal: Fungsionalitas 3, Kualitas kode 3, Git 2–3, Dokumentasi 2–3. Kekurangan yang ditunjuk: `flutter test` merah karena template counter, progres mingguan dan AI disclosure belum menyebut Tugas 8, dan belum ada log chat.

### 8. Review ulang setelah revisi pengguna

**Prompt:** udah coba gw adjust dan rapihin lagi, gw juga udah tambahin tombol reset di AppBar form sertifikasi, coba review lagi dong

**Jawaban AI (ringkas):** memverifikasi diff. Warna sudah seragam ke `colorScheme.primary`, tombol reset ada dan diuji, pemetaan `_pageFor()` menggantikan if/else. Analyze bersih dan test form sertifikasi lulus. Sisa: `widget_test.dart` masih gagal dan pengecekan UI di Chrome belum dilakukan.

### 9. Penyebab nilai belum 3.5–4

**Prompt:** apa yang nahan gw buat dapet 3.5-4?

**Jawaban AI (ringkas):** menjelaskan blocker per rubrik. Fungsionalitas belum terbukti di Chrome. Ada bug docstring `ItemCard` yang tertukar dengan `_pageFor`. Disclosure belum menyebut keterbatasan AI yang konkret. Untuk nilai 4 butuh fitur ekstra yang terlihat, bukan cuma snackbar.

### 10. Cek ulang setelah adjustment

**Prompt:** udah gw adjust, bantu cek lagi dong

**Jawaban AI (ringkas):** docstring `ItemCard` sudah dipindah ke atas kelasnya. Snackbar "Sertifikasi tersimpan" ditambahkan di `certification_form.dart` dan belum di-commit. Analyze bersih dan test form sertifikasi lulus.

### 11. Cek apakah sudah aman

**Prompt:** coba cek sekali lagi, udah aman kah

**Jawaban AI (ringkas):** analyze bersih, `flutter test` hijau (6/6) setelah `widget_test.dart` diganti test menu. Kode aman untuk di-commit, tapi belum aman dikumpulkan: perubahan belum di-commit, snackbar belum diuji, dan alur di Chrome belum dicek pengguna.

### 12. Permintaan log sesi

**Prompt:** btw ai log juga belom ada kan? log session ini dong buat gw masukin

**Jawaban AI (ringkas):** menunjukkan bahwa log sudah ada tapi belum mencakup prompt 7–12. Menyusun entri tambahan dan mengoreksi jumlah test di log (4 → 5).


## Catatan

- `test/widget_test.dart` dari template Flutter masih gagal (counter demo). Tidak diubah karena bukan bagian tugas ini.
- Alur di emulator atau Chrome (tombol back, layar sempit, keyboard tampil) belum diuji oleh AI. Pengecekan itu dilakukan manual oleh pengguna.
