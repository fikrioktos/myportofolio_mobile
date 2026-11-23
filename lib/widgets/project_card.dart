import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Tombol aksi berbentuk kartu berwarna untuk menu portofolio.
///
/// Seluruh permukaan kartu bisa ditekan ([InkWell] dengan efek ripple di
/// atas warna [ItemHomepage.color]); menekannya menampilkan SnackBar yang
/// menyebut nama tombol yang ditekan, lalu menavigasi ke halaman yang sesuai.
/// Memetakan nama tombol aksi ke halaman tujuannya.
///
/// Mengembalikan null untuk tombol yang belum punya halaman (mis. Lihat Proyek).
/// Dipisah dari [ItemCard.build] supaya menambah tombol baru cukup satu baris.
Widget? _pageFor(String name) {
  switch (name) {
    case "Tambah Proyek":
      return const ProjectFormPage();
    case "Tambah Sertifikasi":
      return const CertificationFormPage();
    default:
      return null;
  }
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Warna latar kartu diambil dari atribut color milik item masing-masing.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () {
          // Menampilkan SnackBar dengan pesan interaktif.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text("Kamu telah menekan tombol ${item.name}!")),
            );

          // Navigasi ke halaman yang sesuai lewat peta nama tombol ke halaman.
          final page = _pageFor(item.name);
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
