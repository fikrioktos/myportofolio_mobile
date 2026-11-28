import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Membungkus form dalam MultiProvider supaya Theme, Navigator,
/// ScaffoldMessenger, ApiClient, dan AuthState tersedia seperti saat
/// aplikasi berjalan. Token awal diisi agar ensureLoggedIn langsung
/// mengembalikan true tanpa membuka layar login.
Widget _wrap() {
  final client = ApiClient(
    client: MockClient((request) async => http.Response('[]', 200)),
  );
  return MultiProvider(
    providers: [
      Provider.value(value: client),
      ChangeNotifierProvider(
        create: (context) => AuthState(client, initialToken: 'test-token'),
      ),
    ],
    child: const MaterialApp(home: CertificationFormPage()),
  );
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

    testWidgets('isian kosong menampilkan pesan error dan tidak ada dialog', (
      tester,
    ) async {
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

      expect(
        find.text('URL harus diawali http:// atau https://!'),
        findsOneWidget,
      );
    });
    testWidgets('tombol reset mengosongkan isian dan menghapus pesan error', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());

      await tester.enterText(find.byType(TextFormField).at(0), 'Dicoding');
      await tester.tap(find.text('Simpan'));
      await tester.pump();
      expect(find.text('Lembaga penerbit tidak boleh kosong!'), findsOneWidget);

      await tester.tap(find.byTooltip('Reset formulir'));
      await tester.pump();

      expect(find.text('Dicoding'), findsNothing);
      expect(find.text('Lembaga penerbit tidak boleh kosong!'), findsNothing);
      expect(find.text('Nama sertifikasi tidak boleh kosong!'), findsNothing);
    });
  });
}
