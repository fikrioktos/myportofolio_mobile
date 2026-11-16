# myportofolio_mobile

Aplikasi mobile Flutter untuk portofolio pribadi (Individual Assignment 7 — PBP, CSGE602022).
Aplikasi ini terpisah dari proyek web Django `myportofolio` dan menampilkan identitas pemilik
portofolio beserta tombol aksi menu portofolio.

## Fitur (Tugas 7)

- **InfoCard**: 3 kartu informasi di bagian atas halaman — NPM, Name, dan Class.
- **ItemCard**: 4 tombol aksi dengan warna latar unik per tombol (Lihat Proyek, Lihat Skills,
  Tambah Proyek, Logout). Setiap tombol menampilkan SnackBar "Kamu telah menekan tombol
  [Nama Tombol]!".
- Warna tombol didefinisikan lewat atribut `color` pada model `ItemHomepage` (tanpa if-else).
- Halaman menu utama (`MyHomePage`) berupa `StatelessWidget`, dipisah ke `lib/menu.dart`.

## Setup

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) dan jalankan
   `flutter doctor` untuk memastikan environment siap.
2. Jalankan `flutter pub get` di root folder proyek.
3. Jalankan aplikasi: `flutter run` (pilih device/emulator yang tersedia).
4. Untuk cek kualitas kode: `flutter analyze`.

## Struktur Kode

```
lib/
├── main.dart   # Bootstrap aplikasi (runApp + MaterialApp)
└── menu.dart   # MyHomePage (Stateless), ItemHomepage (model), InfoCard, ItemCard
```

### Tugas 7

1. **Widget tree** adalah struktur hierarkis yang menggambarkan bagaimana widget-widget Flutter
   tersusun untuk membentuk UI. Setiap widget adalah node dalam tree, dan hampir semua widget
   punya widget induk serta bisa punya nol atau lebih widget anak (misalnya lewat properti
   `child` atau `children`). Saat aplikasi dibangun, Flutter memanggil metode `build()` tiap
   widget secara rekursif dari akar (`runApp` → root widget) ke daun, sehingga terbentuk pohon
   lengkap yang kemudian dirender menjadi layar. Hubungan induk–anak bekerja seperti pewarisan
   konfigurasi: induk memberi constraint (batasan ukuran, layout) dan konteks (mis. `Theme`,
   `MediaQuery`) kepada anaknya, sementara anak merender dirinya sesuai data yang diterima lewat
   constructor. Ketika ada widget yang berubah, Flutter membangun ulang (`rebuild`) sub-tree
   tersebut secara efisien — hanya bagian yang berubah yang dirender ulang.

2. Widget yang digunakan dalam proyek ini:
   - `MaterialApp` — root aplikasi; menyediakan konfigurasi global seperti tema, judul, dan
     routing. Mengatur aplikasi sebagai aplikasi bergaya Material.
   - `Scaffold` — struktur visual dasar halaman: menyediakan slot `appBar`, `body`, dan
     mendukung `SnackBar` melalui `ScaffoldMessenger`.
   - `AppBar` — bar atas halaman yang menampilkan judul "MyPortfolio".
   - `Text` — menampilkan teks (judul AppBar, konten kartu, pesan SnackBar).
   - `TextStyle` — memformat tampilan `Text` (ketebalan, ukuran, warna font).
   - `Padding` — memberi jarak di sekeliling widget anaknya.
   - `Column` — menyusun widget anak secara vertikal.
   - `Row` — menyusun widget anak secara horizontal (baris InfoCard).
   - `Center` — memusatkan widget anak di dalamnya.
   - `SizedBox` — kotak berukuran tetap; dipakai untuk memberi jarak (spacing) antar-widget.
   - `GridView.count` — menampilkan ItemCard dalam tata letak kisi 3 kolom dengan
     `shrinkWrap: true` agar tingginya menyesuaikan konten.
   - `Card` — kartu Material untuk InfoCard, dengan elevasi/bayangan.
   - `Container` — wadah dengan padding/dekorasi; dipakai di dalam InfoCard dan ItemCard.
   - `Material` — memberi warna latar dan bentuk (borderRadius) pada ItemCard, sehingga efek
     ripple `InkWell` tampil di atas warna yang benar.
   - `InkWell` — area yang bisa ditekan dengan efek ripple; memicu `onTap` untuk menampilkan
     SnackBar.
   - `Icon` — menampilkan ikon Material (folder, add_circle, logout).
   - `MediaQuery` — mengambil ukuran layar untuk mengatur lebar InfoCard.

3. **`MaterialApp`** adalah widget root yang membungkus sekumpulan widget yang dibutuhkan
   aplikasi bergaya Material: menyediakan `ThemeData` (skema warna, tipografi), sistem navigasi
   (`Navigator` dan named routes), `ScaffoldMessenger` (untuk SnackBar), localization, dan
   jembatan ke widget-layer di bawahnya (`WidgetsApp`). Widget ini umum dipakai sebagai root
   karena tanpanya widget-widget Material (Scaffold, AppBar, SnackBar, dsb.) tidak punya konteks
   tema dan navigasi yang mereka andalkan — banyak widget akan error atau tampil tanpa styling.
   Selain itu `MaterialApp` jadi satu titik konfigurasi global aplikasi (judul, tema, halaman
   awal via `home`, routing).

4. **StatelessWidget** adalah widget yang tidak punya state internal yang berubah — sekali
   dibangun, tampilannya hanya bergantung pada konfigurasi (final fields) yang diberikan lewat
   constructor. State-nya immutable: kalau input berubah, widget dibangun ulang oleh induknya.
   **StatefulWidget** punya objek `State` terpisah yang bertahan antar-rebuild, sehingga widget
   bisa menyimpan data yang berubah (misal counter, input form, animasi) dan memicu
   `setState()` untuk merender ulang tampilannya. Pilih `StatelessWidget` ketika UI murni
   fungsi dari data masukan dan tidak ada kondisi yang berubah sepanjang hidup widget (seperti
   `MyHomePage`, `InfoCard`, `ItemCard` di proyek ini). Pilih `StatefulWidget` ketika widget
   perlu merespons interaksi/waktu dengan mengubah data internalnya sendiri — misalnya
   text field, checkbox, atau halaman yang menarik data dari API lalu menampilkan loading.

5. **BuildContext** adalah handle yang merepresentasikan posisi sebuah widget di dalam widget
   tree. Dengan BuildContext, widget bisa "mencari ke atas" pohon untuk mengakses data dari
   widget leluhur: `Theme.of(context)` mengambil tema terdekat, `MediaQuery.of(context)` ukuran
   layar, dan `ScaffoldMessenger.of(context)` messenger Scaffold terdekat — semuanya butuh
   context untuk tahu dari titik mana pencarian dilakukan. Di dalam metode `build(BuildContext
   context)`, context dipakai persis untuk itu: membaca inherited widget leluhur, dan sebagai
   argumen untuk navigasi (`Navigator.of(context)`) atau menampilkan SnackBar seperti pada
   `ItemCard` di proyek ini. Penting diingat context yang dipakai adalah posisi widget itu
   sendiri — kalau butuh context di bawah `Scaffold` (mis. dari induknya), biasanya dipakai
   `builder` untuk mendapat context yang benar.

6. **Hot reload** menyuntikkan kode baru ke VM yang sedang berjalan lalu membangun ulang widget
   tree — cepat (kurang dari satu detik) dan **state aplikasi dipertahankan** (isi form,
   posisi scroll tetap). **Hot restart** me-reset seluruh state aplikasi ke kondisi awal
   (`main()` dieksekusi ulang) — lebih lama, tapi lebih "bersih". Harus ke hot restart atau
   full restart (stop & run ulang) ketika perubahan menyentuh hal yang tidak bisa di-inject
   hot reload: perubahan di `main()` atau inisialisasi state global/static, perubahan
   deklarasi enum atau tipe, penambahan dependensi di `pubspec.yaml`, perubahan kode native
   (Android/iOS), atau saat terjadi error state yang "hangat" setelah refactor besar (mis.
   mengubah superclass widget). Kalau cuma mengubah isi `build()`, warna, atau layout — hot
   reload cukup.

## Progres Mingguan

| Minggu | Pekerjaan |
|---|---|
| Tutorial 08 | Setup Flutter SDK, inisialisasi proyek `myportofolio_mobile`, pemisahan `menu.dart` dari `main.dart`, `MyHomePage` jadi `StatelessWidget`, penyusunan `InfoCard` dan `ItemCard`. |
| Tugas 7 | Data diri diganti dari contoh Burhan ke identitas pribadi; atribut `Color` pada model `ItemHomepage` supaya tiap tombol punya warna unik tanpa if-else; README, jawaban reflektif, dan AI disclosure; penambahan tombol **Lihat Skills** sebagai fitur ekstra. |

## AI Disclosure

- **Tools yang digunakan**: AI assistant (Hermes Agent, model GLM via OpenRouter) untuk
  membantu implementasi kode, dokumentasi, dan jawaban reflektif.
- **Bagian yang dibantu AI**: penambahan atribut `Color` pada model `ItemHomepage` beserta
  warna tiap tombol, penulisan `README.md` (deskripsi, setup, jawaban Tugas 7, disclosure ini),
  serta pengecekan `flutter analyze`. Struktur dasar proyek, pemisahan `menu.dart`, dan
  perubahan `MyHomePage` menjadi `StatelessWidget` sudah dikerjakan mandiri pada Tutorial 08.
- **Strategi prompting**: spesifikasi tugas (PDF) diberikan utuh ke AI, lalu diminta
  mengeksekusi langsung di repo; hasil diverifikasi dengan `flutter analyze` dan review manual.
- **Keterbatasan AI & perbaikan manual**: AI tidak bisa menjalankan emulator untuk verifikasi
  visual, sehingga pengecekan tampilan akhir (warna kartu, SnackBar, layout layar sempit)
  tetap dilakukan manual oleh saya.
- **Log prompt**: log verbatim prompt dan kutipan jawaban AI tersedia di
  [docs/ai-log-tugas-7.md](docs/ai-log-tugas-7.md).

