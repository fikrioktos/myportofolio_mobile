import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';

/// Membungkus form dalam MaterialApp supaya Theme, Navigator, dan
/// ScaffoldMessenger tersedia seperti saat aplikasi berjalan.
Widget _wrap() {
  return const MaterialApp(home: CertificationFormPage());
}

void main() {
  group('CertificationFormPage', () {
    testWidgets('menampilkan semua input dan tombol Simpan', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.text('Nama Sertifikasi'), findsOneWidget);
      expect(find.text('Lembaga Penerbit'), findsOneWidget);
      expect(find.text('Tanggal Terbit'), findsOneWidget);
      expect(find.text('URL Kredensial'), findsOneWidget);
      expect(find.text('Simpan'), findsOneWidget);
    });

    testWidgets('isian kosong menampilkan pesan error dan tidak ada dialog',
        (tester) async {
      await tester.pumpWidget(_wrap());

      await tester.tap(find.text('Simpan'));
      await tester.pump();

      expect(find.text('Nama sertifikasi tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Lembaga penerbit tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Tanggal terbit wajib dipilih!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('isian berisi spasi saja dianggap kosong', (tester) async {
      await tester.pumpWidget(_wrap());

      await tester.enterText(find.byType(TextFormField).at(0), '   ');
      await tester.tap(find.text('Simpan'));
      await tester.pump();

      expect(find.text('Nama sertifikasi tidak boleh kosong!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('URL tanpa http atau https ditolak', (tester) async {
      await tester.pumpWidget(_wrap());

      await tester.enterText(find.byType(TextFormField).at(4), 'coursera.org');
      await tester.tap(find.text('Simpan'));
      await tester.pump();

      expect(find.text('URL harus diawali http:// atau https://!'),
          findsOneWidget);
    });
  });
}
