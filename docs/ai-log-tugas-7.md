# Log Prompt AI — Tugas 7 (Basic Flutter)

Log verbatim prompt pengguna dan kutipan jawaban AI dari sesi Hermes yang dipakai menyusun langkah pengerjaan Tugas 7, diurutkan berdasarkan waktu.

## Metadata

| Sesi | Model | Periode (WIB) | Jumlah prompt |
|---|---|---|---|
| Buat tutorial langkah tugas-7.pdf | GLM (z-ai) via OpenRouter | 15 Nov 2026 23:35 WIB – 16 Nov 2026 22:32 WIB | 4 |

Pembagian kerja: saya menulis dan mengeksekusi seluruh perintah `flutter` dan `git`, sementara AI membaca spek tugas, menyusun langkah pengerjaan, memberi potongan kode, dan menjalankan verifikasi read-only (`flutter analyze`, review kode dan README).

## Indeks Prompt

| # | Waktu | Prompt |
|---|---|---|
| 1 | 15 Nov 2026 23:35 WIB | bantu gw kerjain @file:`tugas-7.pdf` dong, bikinin langkah step by step kayak tutorial buat kerjain. Buat pertanyaan ref …(dipotong, asli 151 karakter) |
| 2 | 16 Nov 2026 22:26 WIB | udah gw kerjain, bantu review dong |
| 3 | 16 Nov 2026 22:28 WIB | ai disclosure tinggal log dari chat ini aja |
| 4 | 16 Nov 2026 22:32 WIB | lah disclosurenya dari sesi buat totiral langkah tugas-7 aja |

## Prompt dan Jawaban

### 1. 15 Nov 2026 23:35 WIB — Buat tutorial langkah tugas-7.pdf

**Prompt:**

> bantu gw kerjain @file:`tugas-7.pdf` dong, bikinin langkah step by step kayak tutorial buat kerjain. Buat pertanyaan reflektif biar gw yang kerjain aja
> 
> [+ konteks terlampir otomatis: file spek tugas-7.pdf dan pohon folder proyek]

**Jawaban AI (kutipan):**

> Kabar baik dulu: lo udah kelar ~80% tugas ini cuma dari Tutorial 08. Repo `myportofolio_mobile` udah punya `menu.dart` terpisah, `MyHomePage` udah `StatelessWidget`, 3 InfoCard udah isi data lo asli (NPM 2506621655, Fikri Okto Setiadi, PBP D), dan SnackBar-nya udah persis format yang diminta. Yang bener-bener belum ada cuma: **warna unik per tombol**, **`flutter analyze` bersih**, dan **README `### Tugas 7`**. Deadline besok ya (Senin 16 Nov 23.59) — kerjain malem ini.

---

## Step 1 — Buat branch kerja (5 menit)

```bash
cd C:/Users/fikri/Code/PBP/myportofolio_mobile
git switch -c feat/item-card-colors
```

Satu fitur satu branch — ini yang bikin Git rubrik dapet 4.

## Step 2 — Tambah fie …(dipotong, asli 5999 karakter)

### 2. 16 Nov 2026 22:26 WIB — Buat tutorial langkah tugas-7.pdf

**Prompt:**

> udah gw kerjain, bantu review dong

**Jawaban AI (kutipan):**

> Review selesai — semuanya hijau. Checklist spec dicheck satuan:

\| Item spec \| Status \| Bukti \|
\|---\|---\|---\|
\| Lanjut proyek Tutorial 08, `menu.dart` terpisah, `StatelessWidget` \| ✅ \| udah dari sebelumnya, struktur `lib/` bener \|
\| 3 InfoCard data asli (NPM/nama/kelas) \| ✅ \| `menu.dart` — 2506621655, Fikri Okto Setiadi, PBP D \|
\| ≥3 ItemCard + warna unik per tombol, tanpa if-else \| ✅ \| 4 tombol, field `Color color` di model, `items` list isi warna berbeda \|
\| SnackBar "Kamu telah menekan tombol [Nama]!" \| ✅ \| format persis sesuai spek \|
\| `flutter analyze` No issues found \| ✅ \| baru gw jalanin ulang: `No issues found! (ran in 33.6s)` \|
\| Commit bertahap + branch per fitur \| ✅ \| `feat/extra- …(dipotong, asli 2150 karakter)

### 3. 16 Nov 2026 22:28 WIB — Buat tutorial langkah tugas-7.pdf

**Prompt:**

> ai disclosure tinggal log dari chat ini aja

**Jawaban AI (kutipan):**

> Dua sesi yang nyambung Tugas 7: "Kerjakan tugas-7.pdf di myportofolio_mobile" (sesi eksekusinya) dan sesi ini. Gw gabungin dua-duanya, urut waktu. Gw bikinin lognya di temp dulu, lo review sebelum masuk repo:

### 4. 16 Nov 2026 22:32 WIB — Buat tutorial langkah tugas-7.pdf

**Prompt:**

> lah disclosurenya dari sesi buat totiral langkah tugas-7 aja

**Jawaban AI:**

> Berkas ini — dibuat langsung dari rekam sesi tersebut sebagai jawaban atas prompt di atas.
